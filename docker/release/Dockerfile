FROM 334274607422.dkr.ecr.us-east-1.amazonaws.com/casecommons/ruby
HEALTHCHECK --interval=3s --retries=20 CMD ${HEALTHCHECK:-curl -fs localhost:${HTTP_PORT:-3000}}

ENV APP_HOME /intake_api_prototype
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY release /release
RUN dpkg -i /release/*.deb && \
    rm -rf /release && \
    apt-get install --no-install-recommends libpq-dev libxml2 libxslt1.1 -y

ENV BUNDLE_PATH $APP_HOME/ruby_gems

VOLUME ["$APP_HOME/public"]
