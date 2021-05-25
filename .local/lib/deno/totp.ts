import { dirname } from "https://deno.land/std@0.97.0/path/posix.ts";
import { parse as argparse } from "https://deno.land/std@0.97.0/flags/mod.ts";

import { TOTP } from "https://deno.land/x/god_crypto@v1.4.9/src/otp/totp.ts";

const CREDENTIALS_PATH = `${
  Deno.env.get("HOME")
}/.local/share/totp/credentials.json`;

type OpGetItemResult = {
  details: {
    sections: {
      fields: {
        n: string;
        v: string;
      }[] | undefined;
    }[];
  };
};

type OpListItemsResult = {
  overview: {
    tags: string[] | undefined;
  } | undefined;
  uuid: string;
}[];

class CredentialsWriter {
  private token: string;

  constructor() {
    this.token = "";
  }

  async run() {
    Deno.mkdirSync(dirname(CREDENTIALS_PATH), { recursive: true });

    await this.signIn();

    const items = (await this.listItems()).filter((item) =>
      item.overview?.tags?.includes("OTP")
    );

    const credentials: Record<string, string> = {};
    let index = 0;

    for (const item of items) {
      console.log(`Processing items... (${++index}/${items.length})`);

      const detailed = await this.getDetailedItem(item.uuid);
      const totpField = detailed.details.sections.flatMap((section) =>
        section.fields
      ).find((field) => field?.n.startsWith("TOTP_"));

      if (totpField) {
        const url = new URL(totpField.v);
        const params = new URLSearchParams(url.search);
        credentials[params.get("mnemonic") ?? url.host] =
          params.get("secret") ?? "";
      }
    }

    Deno.writeTextFileSync(CREDENTIALS_PATH, JSON.stringify(credentials));
  }

  private async signIn() {
    const token = Deno.env.get("OP_SESSION_my");
    if (token) {
      this.token = token;
    } else {
      const process = Deno.run({
        cmd: ["op", "signin", "--raw", "my"],
        stdout: "piped",
      });
      this.token = new TextDecoder().decode(await process.output()).trim();
    }
  }

  private async listItems(): Promise<OpListItemsResult> {
    const process = Deno.run({
      cmd: ["op", "--cache", "--session", this.token, "list", "items"],
      stdout: "piped",
    });
    const data = new TextDecoder().decode(await process.output());
    return JSON.parse(data);
  }

  private async getDetailedItem(uuid: string): Promise<OpGetItemResult> {
    const process = Deno.run({
      cmd: ["op", "--cache", "--session", this.token, "get", "item", uuid],
      stdout: "piped",
    });
    const data = new TextDecoder().decode(await process.output());
    return JSON.parse(data);
  }
}

const cmds = {
  get(item: string) {
    const data = Deno.readTextFileSync(CREDENTIALS_PATH);
    const credentials = JSON.parse(data);
    const secret = credentials[item];
    console.log(new TOTP(secret).generate());
  },

  list() {
    const data = Deno.readTextFileSync(CREDENTIALS_PATH);
    const credentials = JSON.parse(data);
    Object.keys(credentials).sort().forEach((c: string) => {
      console.log(c);
    });
  },

  async update() {
    await new CredentialsWriter().run();
  },
};

if (import.meta.main) {
  const args = argparse(Deno.args, {
    alias: { list: "l", update: "u" },
    boolean: ["list", "update"],
    string: ["_"],
  });

  if (args.update) {
    await cmds.update();
  }

  if (args.list && args._.length === 0) {
    cmds.list();
  } else if (args._.length === 1) {
    cmds.get(args._[0] as string);
  } else if (!args.update) {
    console.error("usage: totp [--update] (--list | <item>)");
    Deno.exit(1);
  }
}
