#!/usr/bin/env -S deno run --ext=ts -q --allow-read

import * as text from "jsr:@std/text@^1.0.0";
import { TextLineStream } from "jsr:@std/streams@^0.224.5/text-line-stream";

function stdinLines() {
  return Deno.stdin.readable.pipeThrough(new TextDecoderStream()).pipeThrough(
    new TextLineStream(),
  );
}

const commands: { [key: string]: ((args: string[]) => Promise<void>) | null } =
  {
    "general:": null,
    async indent(args: string[]) {
      const depthSpec = args[0] || "";

      const m = /^(\d*)([st]?)$/.exec(depthSpec) ?? [null, "4", "s"];
      const char = m[2] === "t" ? "\t" : " ";
      const depth = Number.parseInt(m[1], 10) || (m[2] === "t" ? 1 : 4);
      const indent = char.repeat(depth);

      for await (const line of stdinLines()) {
        console.log(`${indent}${line}`);
      }
    },
    "convert case:": null,
    async lc() {
      for await (const line of stdinLines()) {
        console.log(line.toLowerCase());
      }
    },
    async uc() {
      for await (const line of stdinLines()) {
        console.log(line.toUpperCase());
      }
    },
    async camel() {
      for await (const line of stdinLines()) {
        console.log(text.toCamelCase(line));
      }
    },
    async kebab() {
      for await (const line of stdinLines()) {
        console.log(text.toKebabCase(line));
      }
    },
    async pascal() {
      for await (const line of stdinLines()) {
        console.log(text.toPascalCase(line));
      }
    },
    async snake() {
      for await (const line of stdinLines()) {
        console.log(text.toSnakeCase(line));
      }
    },
    "encoding:": null,
    async "decode%"() {
      for await (const line of stdinLines()) {
        console.log(decodeURIComponent(line));
      }
    },
    async "encode%"() {
      for await (const line of stdinLines()) {
        console.log(encodeURIComponent(line));
      }
    },
    "markdown:": null,
    async list() {
      for await (const line of stdinLines()) {
        console.log(`- ${line}`);
      }
    },
    async quote() {
      for await (const line of stdinLines()) {
        console.log(`> ${line}`);
      }
    },
  };

export function main(args: string[]) {
  const [command, ...rest] = args;
  const fn = commands[command];

  if (fn) {
    fn(rest);
  } else {
    console.error(`usage: str <command>`);
    console.error(`commands:`);
    for (const [k, v] of Object.entries(commands)) {
      console.error(`  ${v ? "  " : ""}${k}`);
    }
    Deno.exit(1);
  }
}

if (import.meta.main) {
  main(Deno.args);
}
