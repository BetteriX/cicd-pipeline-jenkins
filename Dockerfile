FROM node:7.8.0

WORKDIR /opt

COPY . .
RUN npm install

CMD ["npm", "start"]