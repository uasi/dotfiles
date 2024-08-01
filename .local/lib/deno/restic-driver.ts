#!/usr/bin/env -S deno run --ext=ts -q --allow-read --allow-env=HOME --allow-run=agenvx,restic

import { parseArgs } from "jsr:@std/cli@^1.0.0";
import { join as joinPath } from "jsr:@std/path@^1.0.0";
import { parse as parseToml } from "jsr:@std/toml@^1.0.0";
import * as v from "jsr:@valibot/valibot@^0.37.0";

const CONFIG_DIR = joinPath(Deno.env.get("HOME")!, ".config", "restic-driver");

const CommandOptionsSchema = v.optional(
  v.object({
    args: v.optional(v.array(v.string())),
    cwd: v.optional(v.string()),
  }),
);

const ConfigSchema = v.object({
  repo: v.string(),
  targets: v.array(
    v.object({
      tag: v.string(),
      path: v.union([v.string(), v.array(v.string())]),
      backup: CommandOptionsSchema,
      forget: CommandOptionsSchema,
    }),
  ),
  backup: CommandOptionsSchema,
  forget: CommandOptionsSchema,
});

type Config = v.InferOutput<typeof ConfigSchema>;

async function main() {
  const args = parseArgs(Deno.args, { string: ["_", "agenv"] });
  const envFileName = args.agenv;
  const rest = args._ as string[];

  if (rest.length < 2) {
    console.error(
      "usage: restic-driver [--agenv=<env-file-name>] <command> <config>...",
    );
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

    await runCommand(command, config, envFileName);
  }
}

async function runCommand(
  command: "backup" | "forget",
  config: Config,
  envFileName: string | undefined,
) {
  console.log("########################");
  console.log(new Date().toISOString());
  console.log("########################");

  const repo = expandHome(config.repo);

  for (const { tag, path, ...target } of config.targets) {
    console.log(`=== ${command} ===`);
    console.log(`restic-driver: tag=${tag} path=${path}`);

    const paths = (() => {
      if (typeof path === "string") {
        return [expandHome(path)];
      } else {
        return path.map((p) => expandHome(p));
      }
    })();

    const cwd = target[command]?.cwd ?? config[command]?.cwd;

    const extraArgs = target[command]?.args ?? config[command]?.args ?? [];
    const args = command === "backup"
      ? [command, "--repo", repo, "--tag", tag, ...extraArgs, ...paths]
      : [command, "--repo", repo, "--tag", tag, ...extraArgs];

    const status = await runRestic(args, paths[0], cwd, envFileName);

    if (!status.success) {
      return;
    }
  }
}

async function runRestic(
  args: string[],
  target: string | undefined,
  cwd: string | undefined,
  envFileName: string | undefined,
): Promise<Deno.CommandStatus> {
  const realCwd = cwd === "$CONFIG" ? CONFIG_DIR : cwd;

  const options = { cwd: realCwd, env: { TARGET: target ?? "" } };

  const command = envFileName === undefined
    ? new Deno.Command("restic", { args, ...options })
    : new Deno.Command("agenvx", {
      args: [envFileName, "restic", ...args],
      ...options,
    });

  const child = command.spawn();

  return await child.status;
}

function loadConfig(name: string): Config {
  const configPath = name.includes("/") || name.includes("\\")
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
