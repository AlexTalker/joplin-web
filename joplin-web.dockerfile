# FROM ubuntu:24.04
FROM node:18 AS build

RUN uname -a

ENV DEBIAN_FRONTEND=noninteractive

ENV NODE_OPTIONS="--max-old-space-size=4096"

# RUN apt update && apt install -y curl && rm -rf /var/lib/apt/lists/*

# RUN bash -c 'curl -fsSL https://deb.nodesource.com/setup_22.x | bash -'

# RUN apt update && apt install -y nodejs && rm -rf /var/lib/apt/lists/*

# RUN npm install -g corepack

RUN apt update && apt install -y rsync && rm -rf /var/lib/apt/lists/*

RUN corepack enable

WORKDIR /src

COPY joplin/ .

RUN pwd && ls -lah

# RUN yarn install

RUN --mount=type=cache,target=/src/.yarn/cache --mount=type=cache,target=/src/.yarn/berry/cache\
    BUILD_SEQUENCIAL=1 yarn config set cacheFolder /src/.yarn/cache \
    && yarn install --inline-builds

RUN cd ./packages/app-mobile/ && yarn web

# FROM nginx:1.29
# 
# COPY --from=build /src/packages/app-mobile/web/dist/ /usr/share/nginx/html

FROM scratch

COPY --from=build /src/packages/app-mobile/web/dist/ /static/
