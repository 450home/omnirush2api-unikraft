FROM node:22-alpine AS base

WORKDIR /app

ENV NODE_ENV=production

FROM base AS build

RUN apk add --no-cache git ca-certificates && git clone --depth 1 https://github.com/IMROVOID/Omnirush2API.git .

RUN npm ci --include=dev
RUN npm run build

FROM base AS runtime

COPY package.json /app/package.json
COPY --from=build /app/package-lock.json /app/package-lock.json
RUN npm ci --omit=dev

FROM scratch

COPY --from=base /usr/local/bin/node /usr/bin/node
COPY --from=base /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=base /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1
COPY --from=base /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=base /etc/os-release /etc/os-release

COPY --from=runtime /app/node_modules /app/node_modules
COPY --from=build /app/dist /app/dist
COPY --from=build /app/worker /app/worker
COPY --from=build /app/public /app/public
COPY --from=build /app/package.json /app/package.json

ENV PORT=20129

CMD ["/usr/bin/node", "/app/dist/cli.js", "start", "--host", "0.0.0.0", "--port", "20129"]
