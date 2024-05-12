#!/usr/bin/env -S deno run --ext=ts --allow-net --allow-read --allow-write --allow-env=HOME --allow-run=open

import { parseArgs } from "jsr:@std/cli@^0.224.0";
import { ensureDir } from "jsr:@std/fs@^0.224.0";
import { exists } from "jsr:@std/fs@^0.224.0";
import { dirname } from "jsr:@std/path@^0.224.0";
import * as yaml from "jsr:@std/yaml@^0.224.0";
import { Type as YAMLType } from "jsr:@std/yaml@^0.224.0/type";

export type LoaderOptions = {
  cachePath?: string | null | undefined;
  sources?: string[] | null | undefined;
};

export class Loader {
  static SOURCES: readonly string[] = [
    "https://raw.githubusercontent.com/rubocop/rubocop/master/config/default.yml",
    "https://raw.githubusercontent.com/rubocop/rubocop-rails/master/config/default.yml",
    "https://raw.githubusercontent.com/rubocop/rubocop-rake/master/config/default.yml",
    "https://raw.githubusercontent.com/rubocop/rubocop-rspec/master/config/default.yml",
  ];

  static CACHE_PATH = `${Deno.env.get("HOME")}/.cache/ruboman/cop-list.json`;

  static SCHEMA = yaml.DEFAULT_SCHEMA.extend({
    explicit: [
      new YAMLType("!ruby/regexp", {
        kind: "scalar",
        represent: () => "ignored",
        instanceOf: String,
        construct: () => "ignored",
      }),
    ],
  });

  cachePath: string;
  sources: readonly string[];

  constructor(options?: LoaderOptions) {
    this.cachePath = options?.cachePath ?? Loader.CACHE_PATH;
    this.sources = options?.sources ? [...options.sources] : Loader.SOURCES;
  }

  async load(reload?: boolean): Promise<string[]> {
    if (!reload && await exists(this.cachePath)) {
      const cops = JSON.parse(
        await Deno.readTextFile(this.cachePath),
      ) as string[];
      return [...new Set(cops)].sort();
    }

    await ensureDir(dirname(this.cachePath));

    const sources = await Promise.all(
      this.sources.map((s) => fetch(s).then((r) => r.text())),
    );

    const cops = sources.reduce((acc, source) => {
      const config = yaml.parse(source, { schema: Loader.SCHEMA }) as Record<
        string,
        unknown
      >;
      const cops: string[] = Object.keys(config).filter((key) =>
        key.includes("/")
      );
      return acc.concat(cops);
    }, [] as string[]);

    const sortedCops = [...new Set(cops)].sort();

    await Deno.writeTextFile(this.cachePath, JSON.stringify(sortedCops) + "\n");

    return sortedCops;
  }
}

export async function openURLs(urls: string[]) {
  await Deno.run({
    cmd: ["open", ...urls],
  }).status();
}

export async function openManPages(names: string[]) {
  const urls = names.map((name) => {
    let departments: string[];
    let cop: string | null;

    const parts = name.split("/").map((s) => s.toLowerCase());

    if (parts.length === 1) {
      cop = null;
      departments = parts;
    } else {
      cop = parts.pop() ?? null;
      departments = parts;
    }

    const gem = {
      rails: "rubocop-rails",
      rake: "rubocop-rake",
      rspec: "rubocop-rspec",
    }[departments[0]] ?? "rubocop";
    const page = departments.join("/");
    const fragment = cop ? `#${departments.join("")}${cop}` : "";

    return `https://docs.rubocop.org/${gem}/cops_${page}.html${fragment}`;
  });

  await openURLs(urls);
}

export async function main(rawArgs: string[]) {
  const args = parseArgs(rawArgs, {
    alias: { list: "l", update: "u" },
    boolean: ["list", "update"],
    string: ["_"],
  });
  const names = args._ as string[];

  if (args.list) {
    console.log((await new Loader().load(!!args.update)).join("\n"));
    return;
  } else if (args.update) {
    await new Loader().load(true);
    console.info("info: Updated cop list cache.");
    return;
  }

  if (names.length < 1) {
    await openURLs(["https://docs.rubocop.org/"]);
  } else {
    await openManPages(names);
  }
}

if (import.meta.main) {
  await main(Deno.args);
}
