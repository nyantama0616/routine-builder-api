FROM ruby:3.2.1
ENV ROOT="/app"
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

RUN apt-get update -qq
RUN apt-get install -y postgresql-client

WORKDIR ${ROOT}

COPY Gemfile Gemfile.lock ${ROOT}

RUN gem install bundler
RUN bundle install --jobs 4

COPY . ${ROOT}
