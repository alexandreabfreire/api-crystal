FROM crystallang/crystal

RUN apt-get update

WORKDIR /api

COPY . /api

CMD ./api

RUN shards install

RUN crystal build src/api.cr

EXPOSE 3000

