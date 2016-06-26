from node:argon

COPY . /pastan

RUN cd /pastan; npm install

EXPOSE  8338
WORKDIR /pastan
CMD ["npm", "start"]
