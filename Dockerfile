FROM ruby:2.6.4-alpine3.10

RUN apk add --update \
  build-base \
  libxml2-dev \
  libxslt-dev \
  postgresql-dev

COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri -v '1.10.4'
RUN gem install bundler
RUN bundle install

CMD ["bundle", "exec", "rails","s", "."]