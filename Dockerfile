# Dockerfile
ARG NODE_IMAGE=node:12.16.0-alpine

FROM $NODE_IMAGE

# Install the dependencies in the parent folder so they don't get overriden by the bind mount
WORKDIR /

# We need to install some dependencies for bundlesize (https://github.com/siddharthkp/bundlesize/pull/370)
RUN apk add --no-cache bash python3 make g++ git

# Set up Git configuration
RUN git config --global user.email "standogan@gmail.com" \
    && git config --global user.name "sefai" \
    && git config --global credential.helper "store --file=/tmp/git-credentials"

# Set up Git credentials
RUN echo "https://github.com:$(cat /github_token.txt)@github.com" > /tmp/git-credentials

COPY package.json yarn.lock ./

RUN yarn install

ENV NODE_PATH=/node_modules
ENV PATH=/node_modules/.bin:$PATH

WORKDIR /app
COPY . ./
