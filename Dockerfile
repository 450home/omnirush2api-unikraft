FROM node:22-slim

WORKDIR /app

ENV PATH=/usr/local/bin:$PATH

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates git && update-ca-certificates && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/IMROVOID/Omnirush2API.git .

# devDependencies (tsx/esbuild/typescript) are required for the build step
RUN npm ci --include=dev && npm run build

ENV NODE_ENV=production
ENV PORT=20129

EXPOSE 20129

CMD ["node", "dist/cli.js", "start", "--host", "0.0.0.0", "--port", "20129"]
