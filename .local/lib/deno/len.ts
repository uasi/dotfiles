#!/usr/bin/env -S deno run --ext=ts -q --allow-read

import { toArrayBuffer } from "jsr:@std/streams@^1.0.0";

function lengthOf(iterable: Iterable<unknown>): number {
  let i = 0;

  for (const _ of iterable) {
    i++;
  }

  return i;
}

function chomp(buffer: Uint8Array): Uint8Array {
  let end = 0;

  if (buffer.at(-1) == 0x0A) {
    if (buffer.at(-2) == 0x0D) {
      end = -2;
    } else {
      end = -1;
    }
  }

  return buffer.slice(0, end);
}

export async function getTextLength(
  stream: ReadableStream<Uint8Array>,
): Promise<{ bytes: number; codeUnits: number; codePoints: number; graphemes: number }> {
  const buffer = chomp(new Uint8Array(await toArrayBuffer(stream)));
  const bytes = lengthOf(buffer);

  const decoder = new TextDecoder();
  const text = decoder.decode(buffer);
  const codeUnits = text.length;
  const codePoints = lengthOf(text);

  const segmenter = new Intl.Segmenter();
  const segments = segmenter.segment(text);
  const graphemes = lengthOf(segments);

  return { bytes, codeUnits, codePoints, graphemes };
}

if (import.meta.main) {
  const len = await getTextLength(Deno.stdin.readable);

  console.log(`Bytes       = ${len.bytes}`);
  console.log(`Code units  = ${len.codeUnits}`);
  console.log(`Code points = ${len.codePoints}`);
  console.log(`Graphemes   = ${len.graphemes}`);
}
