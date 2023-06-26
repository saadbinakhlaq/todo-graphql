FROM ruby:3.1
LABEL maintainer="name@xyz.com"
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install bash-completion wget

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && apt-get -y install postgresql-client-12

ENV APPDIR /opt/app

RUN mkdir -p $APPDIR
RUN gem install rails bundler
WORKDIR $APPDIR
COPY Gemfile* ./
RUN bundle install
COPY . ./

CMD ./docker-entrypoint.sh