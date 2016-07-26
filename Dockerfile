FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client
RUN mkdir /casebook_api
WORKDIR /casebook_api
ADD Gemfile /casebook_api/Gemfile
ADD Gemfile.lock /casebook_api/Gemfile.lock
RUN bundle install
ADD . /casebook_api
