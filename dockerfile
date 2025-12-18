FROM ruby:3.3-slim

ENV APP_HOME=/app \
    BUNDLE_PATH=/gems \
    RACK_ENV=production

WORKDIR $APP_HOME

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libssl-dev \
      && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4 --retry 3

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "falcon", "serve", "--bind", "http://0.0.0.0:3000"]
