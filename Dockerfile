FROM node:7.8.0

WORKDIR /opt

COPY package.json /opt/package.json
RUN npm install

CMD ["npm", "start"]