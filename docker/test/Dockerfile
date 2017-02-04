FROM ruby:2.4.0
LABEL application=intake_api_prototype
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client

ENV APP_HOME /intake_api_prototype
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile Gemfile.lock $APP_HOME/

ENV BUNDLE_PATH $APP_HOME/ruby_gems
RUN bundle config build.nokogiri --use-system-libraries

RUN bundle install -j24

RUN mkdir /build_artefacts
COPY scripts/build.sh /usr/local/bin/build.sh
RUN chmod +x /usr/local/bin/build.sh

COPY . $APP_HOME

