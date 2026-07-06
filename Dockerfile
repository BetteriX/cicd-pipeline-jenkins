FROM node:7.8.0

WORKDIR /opt

COPY package*.json ./
RUN npm install

COPY . .

CMD ["npm", "start"]