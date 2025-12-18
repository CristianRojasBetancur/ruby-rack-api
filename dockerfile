FROM ruby:3.4.7-slim

ENV APP_HOME=/app \
    BUNDLE_PATH=/gems \
    RACK_ENV=development

WORKDIR $APP_HOME

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libssl-dev \
      libyaml-dev \
      && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "falcon", "serve", "--bind", "http://0.0.0.0:3000"]
