FROM oven/bun

WORKDIR /app

COPY bun.lockb bunfig.toml package.json tsconfig.json .env.sample ./
COPY src ./src
# COPY index.ts ./

RUN bun install

RUN bun run build

CMD ["bun", "run", "start"]
