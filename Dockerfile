FROM ruby:3.1
LABEL maintainer="name@xyz.com"

ENV APPDIR /opt/app

RUN mkdir -p $APPDIR
RUN gem install rails bundler
WORKDIR $APPDIR
COPY Gemfile* ./
RUN bundle install
COPY . ./

CMD ./docker-entrypoint.sh