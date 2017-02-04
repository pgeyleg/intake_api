FROM 429614120872.dkr.ecr.us-west-2.amazonaws.com/cwds/intake-base

ENV APP_HOME /intake_api_prototype
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY release /release
RUN dpkg -i /release/*.deb && \
    rm -rf /release && \
    apt-get install --no-install-recommends libpq-dev libxml2 libxslt1.1 -y

ENV BUNDLE_PATH $APP_HOME/ruby_gems

VOLUME ["$APP_HOME/public"]