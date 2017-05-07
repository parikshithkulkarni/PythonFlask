FROM ruby:2.3-slim
MAINTAINER Parikshith Kulkarni <pkulkarni@znalytics.com>

RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client-9.4 --fix-mixing --no-recommends

ENV INSTALL_PATH /mobydock
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile
RUN bundle install

COPY . .

RUN bundle exec rake RAILS_ENV=production DATABASE_URL=postgreql://user:pass@127.0.0.1/dbname SECRE_TOKEN=pickasecuretoken assets:precompile

VOLUME["$INSTALL_PATH/public"]

CMD bundle exec unicorn -c config/unicorn.rb