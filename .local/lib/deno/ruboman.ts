async function openUrls(urls: string[]) {
  await Deno.run({
    cmd: ["open", ...urls],
  }).status();
}

async function openManPages(names: string[]) {
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
  await openUrls(urls);
}

if (import.meta.main) {
  if (Deno.args.length < 1) {
    await openUrls(["https://docs.rubocop.org/"]);
  } else {
    await openManPages(Deno.args);
  }
}
