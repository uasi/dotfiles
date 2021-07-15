import { h } from "https://x.lcas.dev/preact@10.5.12/mod.js";
import { renderToString } from "https://x.lcas.dev/preact@10.5.12/ssr.js";

const endpoint = (Deno.env.get("API_ENDPOINT") ?? "").replace(/\/+$/, "");

if (endpoint === "") {
  console.error("error: API_ENDPOINT must be set.");
  // Deno.exit(1);
}

const script = `
document.querySelectorAll('input[name=token]').forEach(function(input) {
  input.value = document.location.hash.replace(/^#/, '');
});
`;

function App() {
  return (
    <html>
      <head>
        <title>phog web</title>
      </head>
      <body>
        <h1>phog web</h1>
        <p>
          <code>api = {endpoint}</code>
        </p>
        <h2>Tweets</h2>
        <form method="post" action={`${endpoint}/tweets`}>
          <input type="text" name="token" placeholder="AUTH_TOKEN" />
          <br />
          <textarea name="text" placeholder="Tweets" rows={10} cols={80} />
          <br />
          <input type="submit" />
        </form>
        <h2>User</h2>
        <form method="post" action={`${endpoint}/user`}>
          <input type="text" name="token" placeholder="AUTH_TOKEN" />
          <br />
          <textarea name="text" placeholder="User" rows={10} cols={80} />
          <br />
          <input type="submit" />
        </form>
        <script>{script}</script>
      </body>
    </html>
  );
}

addEventListener("fetch", (event) => {
  const response = new Response("<!DOCTYPE html>" + renderToString(<App />), {
    headers: {
      "Content-Type": "text/html; charset=utf-8",
    },
  });

  event.respondWith(response);
});
