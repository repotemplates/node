# Build
FROM node:alpine3.20 AS base

ENV GENERATE_SOURCEMAP=false
ENV CI=true
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

COPY . ./

# Production

# Trace the Docker image used above to its build of Alpine
FROM alpine:3.20 AS prod
ENV NODE_ENV=production
COPY --from=base /usr/local/bin/node /usr/local/bin/
COPY --from=base /usr/lib/libgcc* /usr/lib/libstdc* /usr/lib/

WORKDIR /app
COPY --chown=nobody:nobody --from=base /app .

USER nobody
#EXPOSE 3000

CMD ["node", "index.js"]
