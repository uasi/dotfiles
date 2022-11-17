import { parse as argparse } from "https://deno.land/std@0.165.0/flags/mod.ts";

export async function main(rawArgs: string[] = Deno.args) {
  const args = argparse(rawArgs, {
    alias: { hello: "H" },
    boolean: ["hello"],
    string: ["_"],
  });

  const rest = args._ as string[];

  if (args.hello) {
    console.log("Hello!");
  }

  console.log(`Args: ${JSON.stringify(rest)}`);
}

if (import.meta.main) {
  await main();
}
