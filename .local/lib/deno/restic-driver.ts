#!/usr/bin/env -S deno run --ext=ts -q --allow-read --allow-env=HOME --allow-run=restic,rotx

import { parseArgs } from "jsr:@std/cli@^0.224.0";
import { join as joinPath } from "jsr:@std/path@^0.224.0";
import { parse as parseToml } from "jsr:@std/toml@^0.224.0";
import * as v from "jsr:@valibot/valibot@^0.30.0";

const CONFIG_DIR = joinPath(Deno.env.get("HOME")!, ".config", "restic-driver");

const CommandOptionsSchema = v.optional(
  v.object({
    args: v.optional(v.array(v.string())),
    cwd: v.optional(v.string()),
  })
);

const ConfigSchema = v.object({
  repo: v.string(),
  targets: v.array(
    v.object({
      tag: v.string(),
      path: v.string(),
      backup: CommandOptionsSchema,
      forget: CommandOptionsSchema,
    })
  ),
  backup: CommandOptionsSchema,
  forget: CommandOptionsSchema,
});

type Config = v.Output<typeof ConfigSchema>;

async function main() {
  const args = parseArgs(Deno.args, { string: ["_", "rot-key"] });
  const rotKey = args["rot-key"];
  const rest = args._ as string[];

  if (rest.length < 2) {
    console.error("usage: restic-driver [--rot-key=<key>] <command> <config>...");
    Deno.exit(1);
  }

  const command = rest[0];
  const configNames = rest.slice(1);

  if (command !== "backup" && command !== "forget") {
    console.error(`error: unknown command: ${command}`);
    Deno.exit(1);
  }

  for (const configName of configNames) {
    const config = loadConfig(configName);

    await runCommand(command, config, rotKey);
  }
}

async function runCommand(
  command: "backup" | "forget",
  config: Config,
  rotKey: string | undefined
) {
  console.log("########################");
  console.log(new Date().toISOString());
  console.log("########################");

  const repo = expandHome(config.repo);

  for (const { tag, path: rawPath, ...target } of config.targets) {
    console.log(`=== ${command} ===`);
    console.log(`restic-driver: tag=${tag} path=${rawPath}`);

    const path = expandHome(rawPath);

    const cwd = target[command]?.cwd ?? config[command]?.cwd;

    const extraArgs = target[command]?.args ?? config[command]?.args ?? [];
    const args =
      command === "backup"
        ? [command, "--repo", repo, "--tag", tag, ...extraArgs, path]
        : [command, "--repo", repo, "--tag", tag, ...extraArgs];

    const status = await runRestic(args, path, cwd, rotKey);

    if (!status.success) {
      return;
    }
  }
}

async function runRestic(
  args: string[],
  target: string,
  cwd: string | undefined,
  rotKey: string | undefined
): Promise<Deno.CommandStatus> {
  const realCwd =
    cwd === "$CONFIG"
      ? CONFIG_DIR
      : cwd === "$HOME"
      ? Deno.env.get("HOME")!
      : cwd === "$TARGET"
      ? target
      : cwd;

  const options = { cwd: realCwd, env: { TARGET: target } };

  const command =
    rotKey === undefined
      ? new Deno.Command("restic", { args, ...options })
      : new Deno.Command("rotx", {
          args: [rotKey, "run", "restic", ...args],
          ...options,
        });

  const child = command.spawn();

  return await child.status;
}

function loadConfig(name: string): Config {
  const configPath =
    name.includes("/") || name.includes("\\")
      ? name
      : joinPath(CONFIG_DIR, name + ".toml");

  return v.parse(ConfigSchema, parseToml(Deno.readTextFileSync(configPath)));
}

function expandHome(path: string): string {
  return path.replace(/^~\//, Deno.env.get("HOME")! + "/");
}

if (import.meta.main) {
  main();
}
