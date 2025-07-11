import { serve } from "bun";
import type { Context, HTTPMethod, Middleware, RequestHandler } from "../types/bun.d.types";

class BunPress {
  public routes: Map<string, RequestHandler>;
  public middlewares: Middleware[];

  constructor() {
    this.routes = new Map();
    this.middlewares = [];
  }

  use(middleware: Middleware) {
    this.middlewares.push(middleware);
  }

  addRoute(method: HTTPMethod, path: string, handler: RequestHandler) {
    const key = `${method.toUpperCase()} ${path}`;
    this.routes.set(key, handler);
  }

  get(path: string, handler: RequestHandler) {
    this.addRoute("GET", path, handler);
  }

  post(path: string, handler: RequestHandler) {
    this.addRoute("POST", path, handler);
  }

  put(path: string, handler: RequestHandler) {
    this.addRoute("PUT", path, handler);
  }

  delete(path: string, handler: RequestHandler) {
    this.addRoute("DELETE", path, handler);
  }

  async handleRequest(req: Request): Promise<Response> {
    const { method } = req;
    const url = new URL(req.url);
    const key = `${method} ${url.pathname}`;
    const handler = this.routes.get(key);

    if (!handler) {
      return new Response("Not Found", { status: 404 });
    }

    const context: Context = { req };

    for (const middleware of this.middlewares) {
      await middleware(context);
    }

    return handler(context); // Ensure the callback runs
  }

  listen(port: number, callback?: () => void) {
    const server = serve({
      port,
      fetch: (req: Request) => this.handleRequest(req),
    });

    if (callback) {
      callback();
    }

    return server;
  }
}

export default BunPress;