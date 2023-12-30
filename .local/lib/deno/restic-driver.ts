#!/usr/bin/env -S deno run --ext=ts -q --allow-read --allow-env=HOME --allow-run=restic,rotx

import { parseArgs } from "https://deno.land/std@0.210.0/cli/mod.ts";
import { join as joinPath } from "https://deno.land/std@0.210.0/path/mod.ts";
import { parse as parseToml } from "https://deno.land/std@0.210.0/toml/mod.ts";
import * as v from "https://deno.land/x/valibot@v0.25.0/mod.ts";

const CONFIG_DIR = joinPath(Deno.env.get("HOME")!, ".config", "restic-driver");

const ConfigSchema = v.object({
    repo: v.string(),
    targets: v.array(v.object({ tag: v.string(), path: v.string() })),
    backup: v.optional(v.object({ args: v.optional(v.array(v.string())) })),
    forget: v.optional(v.object({ args: v.optional(v.array(v.string())) })),
});

type Config = v.Output<typeof ConfigSchema>;

async function main() {
    const args = parseArgs(Deno.args, { string: ["_", "rot-key"] });
    const rotKey = args["rot-key"];
    const rest = args._ as string[];

    if (rest.length < 2) {
        console.error("usage: restic-driver [--rot-key=<key>] <command> <config>");
        Deno.exit(1);
    }

    const command = rest[0];
    const configName = rest[1];

    if (command !== "backup" && command !== "forget") {
        console.error(`error: unknown command: ${command}`);
        Deno.exit(1);
    }

    const config = loadConfig(configName);

    await runCommand(command, config, rotKey);
}

async function runCommand(command: "backup" | "forget", config: Config, rotKey: string | undefined) {
    console.log("########################");
    console.log(new Date().toISOString());
    console.log("########################");

    const repo = expandHome(config.repo);
    const extraArgs = config[command]?.args ?? [];


    for (const { tag, path: rawPath } of config.targets) {
        console.log(`=== ${command} ===`);
        console.log(`restic-driver: tag=${tag} path=${rawPath}`);

        const path = expandHome(rawPath);
        const args =
            command === "backup"
                ? ["--repo", repo, command, "--tag", tag, ...extraArgs, path]
                : ["--repo", repo, command, "--tag", tag, ...extraArgs];

        const status = await runRestic(args, rotKey);

        if (!status.success) {
            return;
        }
    }
}

async function runRestic(args: string[], rotKey: string | undefined): Promise<Deno.CommandStatus> {
    const command =
        rotKey === undefined
            ? new Deno.Command("restic", { args })
            : new Deno.Command("rotx", { args: [rotKey, "run", "restic", ...args] });

    const child = command.spawn();

    return await child.status;
}

function loadConfig(name: string): Config {
    const configPath = name.includes("/") || name.includes("\\") ? name : joinPath(CONFIG_DIR, name + ".toml");

    return v.parse(ConfigSchema, parseToml(Deno.readTextFileSync(configPath)));
}

function expandHome(path: string): string {
    return path.replace(/^~\//, Deno.env.get("HOME")! + "/");
}

if (import.meta.main) {
    main();
}
