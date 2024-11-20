#!/usr/bin/env -S deno run --ext=ts -q --allow-env --allow-read

import { parseArgs } from "jsr:@std/cli@1";
import { toText } from "jsr:@std/streams@1";

import createDOMPurify from "npm:dompurify@3";
import { JSDOM } from "npm:jsdom@25";
import { Readability } from "npm:@mozilla/readability@0.5";

async function main() {
  const args = parseArgs(Deno.args, {
    "--": true,
    alias: { help: "h" },
    boolean: ["debug", "help"],
    negatable: ["debug"],
    string: ["_"],
  });

  if (args.help) {
    console.log("usage: readabilitify [--debug] [<file> | -]");

    Deno.exit(0);
  }

  const inputFile = args._[0];

  if (inputFile == null && Deno.stdin.isTerminal()) {
    console.error("error: No input specified");

    Deno.exit(1);
  }

  let input;

  if (inputFile == null || inputFile === "-") {
    input = Deno.stdin.readable;
  } else {
    try {
      input = (await Deno.open(inputFile, { read: true })).readable;
    } catch {
      console.error(`error: Could not open input file '${inputFile}'`);

      Deno.exit(1);
    }
  }

  let dirty;

  try {
    dirty = await toText(input);
  } catch {
    console.error("error: Could not read input");

    Deno.exit(1);
  }

  const article = parse(dirty, { debug: args.debug });

  console.log(JSON.stringify(article, null, 2));
}

export function parse(
  dirty: string,
  options?: { debug?: boolean },
): ReturnType<typeof Readability.prototype.parse> {
  const { window } = new JSDOM("");

  const purify = createDOMPurify(window);
  const clean = purify.sanitize(dirty);
  window.document.documentElement.innerHTML = clean;

  const consoleLog = console.log;
  console.log = console.error;
  const output = new Readability(window.document, {
    debug: options?.debug ?? false,
  }).parse();
  console.log = consoleLog;

  return output;
}

if (import.meta.main) {
  await main();
}
