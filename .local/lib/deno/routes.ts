import { parse as argparse } from "https://deno.land/std@0.97.0/flags/mod.ts";

type Route = {
  name: string;
  method: string;
  path: string;
  action: string;
};
class Query {
  words: { kind: keyof Route; value: string }[];

  constructor(args: string[]) {
    this.words = [];

    for (const arg of args) {
      if (/[A-Z|]/.test(arg)) {
        this.words.push({ kind: "method", value: arg });
      } else if (/^\//.test(arg)) {
        this.words.push({ kind: "path", value: arg.replace(/^\//, "") });
      } else if (/#/.test(arg)) {
        this.words.push({ kind: "action", value: arg.replace(/^#/, "") });
      } else {
        this.words.push({ kind: "name", value: arg });
      }
    }
  }
  exec(routes: Route[]): Route[] {
    const matches = [];

    for (const route of routes) {
      for (const word of this.words) {
        if (route[word.kind] !== "" && route[word.kind].includes(word.value)) {
          matches.push({ ...route });
          continue;
        }
      }
    }

    return matches;
  }
}

function parseRoutesFile(path: string): Route[] {
  const data = Deno.readTextFileSync(path);

  const routes = [];
  let prevName: string | undefined;
  let prevMethod: string | undefined;
  let prevAction: string | undefined;

  for (const line of data.split(/\r\n|\n|\r/)) {
    const match = line.trim().match(
      /^(?:(?:(?<name>\S+)\s+)?(?<method>[A-Z|]+)\s+)?(?<path>\/\S+)(?:\s+(?<action>.+))?$/,
    );
    if (!match) {
      continue;
    }

    const { name, method, path, action } = match.groups! as {
      name: string | undefined;
      method: string | undefined;
      path: string;
      action: string | undefined;
    };
    routes.push({
      name: name ?? prevName ?? "",
      method: method ?? prevMethod ?? "",
      path,
      action: action ?? prevAction ?? "",
    });

    prevName = name;
    prevMethod = method;
    prevAction = action;
  }

  return routes;
}

function abort(message: string): never {
  console.error(`error: ${message}`);
  console.error(`usage: routes [--raw] <file> <query>...`);
  Deno.exit(1);
}

if (import.meta.main) {
  const args = argparse(Deno.args, {
    alias: { raw: "r" },
    boolean: ["raw"],
    string: ["_"],
  });
  const [file, ...rawQuery] = args._ as string[];

  if (!file) {
    abort("File is not given.");
  }
  if (rawQuery.length === 0) {
    abort("Query is not given.");
  }

  const routes = parseRoutesFile(file);
  const query = new Query(rawQuery);
  const matches = query.exec(routes);

  if (args.raw) {
    matches.forEach((m) =>
      console.log(`${m.name}\t${m.method}\t${m.path}\t${m.action}`)
    );
  } else {
    console.table(matches);
  }
}
