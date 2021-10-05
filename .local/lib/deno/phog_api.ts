import {
  Application,
  Router,
  RouterContext,
} from "https://deno.land/x/oak@v9.0.1/mod.ts";

const authToken = Deno.env.get("AUTH_TOKEN");
const dataDir = Deno.env.get("DATA_DIR");

if (typeof authToken === "undefined" || !/^[0-9A-Za-z]+$/.test(authToken)) {
  console.error("error: AUTH_TOKEN must be set to alphanumeric string.");
  Deno.exit(1);
}

if (typeof dataDir === "undefined" || !Deno.statSync(dataDir).isDirectory) {
  console.error("error: DATA_DIR must be set to an existing directory.");
  Deno.exit(1);
}

const app = new Application();
const router = new Router();

app.addEventListener("listen", ({ hostname, port, secure }) => {
  console.log(
    `Listening on ${secure ? "https://" : "http://"}${hostname ??
      "localhost"}:${port}`,
  );
});

app.addEventListener("error", (evt) => {
  console.log(evt.error);
});

const makeHandler = (filename: string) =>
  async (ctx: RouterContext, next: () => Promise<unknown>) => {
    const params = await ctx.request.body({ type: "form" }).value;
    if (!params.has("token") || !params.has("text")) {
      ctx.throw(400);
    }
    if (params.get("token") !== authToken) {
      ctx.throw(401);
    }

    const text = params.get("text") ?? "";
    if (text.length > 0) {
      Deno.writeTextFileSync(`${dataDir}/${filename}`, text + "\n", {
        append: true,
      });
    }
    ctx.response.status = 204;

    await next();
  };

router.post("/tweets", makeHandler("tweets.txt"));
router.post("/user", makeHandler("user.txt"));

app.use(router.routes());
app.use(router.allowedMethods());

const portEnv = parseInt(Deno.env.get("PORT") ?? "", 10);
const port = 1 <= portEnv && portEnv <= 65535 ? portEnv : 8000;

await app.listen({ port: port });
