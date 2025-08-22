#!/usr/bin/env -S deno run --ext=ts -q --allow-read

import * as text from "jsr:@std/text@^1.0.0";
import { TextLineStream } from "jsr:@std/streams@^1.0.0/text-line-stream";

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
    async repeat(args: string[]) {
      const times = Number.parseInt(args[0] || "") || 1;

      for await (const line of stdinLines()) {
        console.log(line.repeat(times));
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
    "convert number": null,
    async radix(args: string[]) {
      function parseRadix(s) {
        const radix = s.trimStart("0").toLowerCase();

        if ((/^\d+$/).test(s)) {
          const n = parseInt(s, 10);
          return 2 <= n && n <= 36 ? n : undefined;
        }

        return { b: 2, o: 8, d: 10, h: 16, x: 16 }[radix];
      }

      function parseNumber(s) {
        const match = s.match(/^(-?)(?:0?([bodhx]))?(.+)$/i);
        if (!match) return NaN;

        const [, sign, prefix, digits] = match;
        const radix = prefix ? (parseRadix(prefix) || 10) : 10;

        return parseInt(`${sign}${digits}`, radix);
      }

      if (args.length !== 2) {
        console.error(
          "usage: str radix [0b|0o|0d|0h|0x]<input-number> <output-radix>",
        );
        Deno.exit(1);
      }

      const input = parseNumber(args[0]);
      if (isNaN(input)) {
        console.error("error: input is not a number");
        Deno.exit(1);
      }

      const radix = parseRadix(args[1]);
      if (radix == null) {
        console.error("error: output radix is invalid");
        Deno.exit(1);
      }

      console.log(input.toString(radix));
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
