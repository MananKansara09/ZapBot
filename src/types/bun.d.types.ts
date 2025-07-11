export type HTTPMethod = "GET" | "POST" | "PUT" | "DELETE";
export type RequestHandler = (ctx: Context) => Response | Promise<Response>;
export type Middleware = (ctx: Context) => void | Promise<void>;

export interface Context {
  req: Request;
  [key: string]: any; // Allow other properties
}
