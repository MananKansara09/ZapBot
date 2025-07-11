import { PORT } from "./config";
import BunPress from "./utils/bun";

const app = new BunPress();

app.use(async (ctx) => {
  try {
    const contentType = ctx.req.headers.get("content-type");
    if (contentType && contentType.includes("application/json")) {
      ctx.body = await ctx.req.json();
    }
  } catch (error) {
    console.error("Error parsing JSON:", error);
  }
});
app.get("/", async (ctx) => {
  return new Response("Hello World", { status: 200 });
});
// Telegram webhook endpoint
app.post("/webhook", async (ctx) => {
  try {
    // Extract the channel query parameter
    const url = new URL(ctx.req.url);
    const channel = url.searchParams.get("channel");

    console.log(`Received webhook request from channel: ${channel}`);
    console.log("Webhook body:", ctx.body);

    // You can add channel-specific logic here
    if (channel === "telegram") {
      // Process Telegram-specific webhook data
      // For example, you might want to handle different types of Telegram updates
      if (ctx.body && ctx.body.message) {
        console.log("Received message:", ctx.body.message);
      }
    }

    return new Response("OK", { status: 200 });
  } catch (error) {
    console.error("Error handling webhook:", error);
    return new Response("Internal Server Error", { status: 500 });
  }
});

app.get("/webhook/setup", async (ctx) => {
  const url = new URL(ctx.req.url);
  const mode = url.searchParams.get("hub.mode");
  const token = url.searchParams.get("hub.verify_token");
  const challenge = url.searchParams.get("hub.challenge");
  console.log(mode)
  console.log(token)
  const VERIFY_TOKEN = "your_custom_verify_token"; // same one you used in Facebook Developer Console

  if (mode === "subscribe" && token === VERIFY_TOKEN) {
    console.log("WEBHOOK_VERIFIED");
    return new Response(challenge, { status: 200 });
  } else {
    return new Response("Forbidden", { status: 403 });
  }
});

app.listen(Number(PORT) || 3000, () => {
  console.log(`Telegram webhook server listening on port ${PORT}`);
});
