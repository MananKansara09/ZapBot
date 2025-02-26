import { serve } from "bun";

const server = serve({
  port: 8080,
  fetch(req) {
    // Extract IP from common headers (reverse proxies like Cloudflare, Nginx, AWS)
    const ip =
      req.headers.get("x-forwarded-for") || // Most common for proxies
      req.headers.get("cf-connecting-ip") || // Cloudflare proxy
      req.headers.get("x-real-ip") || // Nginx
      "Unknown"; // Fallback if no IP found

    const userAgent = req.headers.get("user-agent") || "Unknown";

    const logData = {
      timestamp: new Date().toISOString(),
      ip,
      method: req.method,
      url: req.url,
      userAgent,
    };

    console.log(JSON.stringify(logData, null, 2));

    return new Response("Hello from Bun HTTP Server! manan", {
      headers: { "Content-Type": "text/plain" },
    });
  },
});

console.log(`Server running on http://localhost:${server.port}`);
