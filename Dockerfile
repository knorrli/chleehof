FROM ruby:2.6.5

RUN apt-get update -qq && apt-get install -y postgresql-client
# throw errors if Gemfile has been modified since Gemfile.lock
RUN gem install bundler
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["bundle", "exec", "padrino", "start", "-h", "0.0.0.0"]
