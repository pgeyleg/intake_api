FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev software-properties-common

RUN add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main"
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
RUN apt-get update && apt-get install -y postgresql-client-9.5

ENV APP_HOME /casebook_api
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME

ENV BUNDLE_PATH /ruby_gems
RUN bundle config build.nokogiri --use-system-libraries
