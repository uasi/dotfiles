import * as yaml from "https://deno.land/std@0.99.0/encoding/yaml.ts";
import { Type as YAMLType } from "https://deno.land/std@0.99.0/encoding/_yaml/type.ts";
import { parse as argparse } from "https://deno.land/std@0.99.0/flags/mod.ts";
import { ensureDir } from "https://deno.land/std@0.99.0/fs/ensure_dir.ts";
import { exists } from "https://deno.land/std@0.99.0/fs/exists.ts";
import { dirname } from "https://deno.land/std@0.99.0/path/mod.ts";

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
  const args = argparse(rawArgs, {
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
