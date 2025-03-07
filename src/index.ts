// create bun http server
import { serve } from "bun";

const server = serve({
  port: 8080,
  fetch() {
    return new Response("Hello World!");
  }
});

console.log(`Server running on http://localhost:${server.port}`);
