#!/usr/bin/env -S deno run --ext=ts -q --allow-read

function lengthOf(iterable: Iterable): number {
  let i = 0;

  for (const _ of iterable) {
    i++;
  }

  return i;
}

const decoder = new TextDecoder();
const segmenter = new Intl.Segmenter();

for await (const chunk of Deno.stdin.readable) {
  const bytes = lengthOf(chunk);

  const text = decoder.decode(chunk);
  const codepoints = lengthOf(text);

  const segments = segmenter.segment(text);
  const graphemes = lengthOf(segments);

  console.log(`bytes      ${bytes}`);
  console.log(`codepoints ${codepoints}`);
  console.log(`graphemes  ${graphemes}`);
}
