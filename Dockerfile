FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client

ENV APP_HOME /casebook_api
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile $APP_HOME/Gemfile
ADD Gemfile.lock $APP_HOME/Gemfile.lock

ENV BUNDLE_PATH /ruby_gems

ADD . $APP_HOME
