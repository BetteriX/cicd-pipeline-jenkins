FROM node:22-alpine

WORKDIR /app

RUN npm install -g npm@11.18.0

COPY package*.json ./
RUN npm ci

COPY . .

USER node

CMD [ "npm", "run", "start" ]