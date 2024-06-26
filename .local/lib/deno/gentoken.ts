#!/usr/bin/env -S deno run --ext=ts

import { parseArgs } from "jsr:@std/cli@^0.224.0";
import { encodeBase32 as base32 } from "jsr:@std/encoding@^0.224.0/base32";
import { encodeBase58 as base58 } from "jsr:@std/encoding@^0.224.0/base58";
import { encodeBase64 as base64 } from "jsr:@std/encoding@^0.224.0/base64";
import { encodeBase64Url as base64url } from "jsr:@std/encoding@^0.224.0/base64url";

const defaultBytes = 24;
const defaultEncoder = base64;
const encoders = Object.assign(Object.create(null), {
  base32,
  base58,
  base64,
  base64url,
  hex: (a: Uint8Array) =>
    Array.from(a).map((i) => i.toString(16).padStart(2, "0")).join(""),
});

export async function main(rawArgs: string[] = Deno.args) {
  const args = parseArgs(rawArgs, {
    alias: { b: "bytes", h: "help", t: "type" },
    boolean: ["help"],
    string: ["bytes", "type", "_"],
  });

  const bytes = args.bytes ? Number.parseInt(args.bytes, 10) : defaultBytes;
  const encode = args.type ? encoders[args.type] : defaultEncoder;

  if (Number.isNaN(bytes) || bytes < 1) {
    console.error("error: bytes must be a positive number");
    Deno.exit(1);
  }

  if (!encode) {
    console.error(
      `error: type must be one of (${Object.keys(encoders).join("|")})`,
    );
    Deno.exit(1);
  }

  if (args.help) {
    console.log(
      `usage: gentoken [--bytes <num>] [--type (${
        Object.keys(encoders).join("|")
      })]`,
    );
    return;
  }

  const buf = new Uint8Array(bytes);
  crypto.getRandomValues(buf);

  console.log(encode(buf));
}

if (import.meta.main) {
  await main();
}
