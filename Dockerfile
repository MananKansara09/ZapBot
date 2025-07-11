FROM oven/bun

WORKDIR /app

COPY bun.lockb bunfig.toml package.json tsconfig.json .env.sample ./
COPY src ./src
# COPY index.ts ./

RUN bun install

RUN bun run build

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bun", "run", "start"]
