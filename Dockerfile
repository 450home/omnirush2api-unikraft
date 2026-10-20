FROM alpine:latest

WORKDIR /app

ENV NODE_ENV=production
ENV PATH=/usr/local/bin:$PATH

RUN apk add --no-cache ca-certificates git nodejs npm

RUN git clone --depth 1 https://github.com/IMROVOID/Omnirush2API.git .

RUN npm ci --include=dev && npm run build

ENV PORT=20129

EXPOSE 20129

CMD ["node", "dist/cli.js", "start", "--host", "0.0.0.0", "--port", "20129"]
