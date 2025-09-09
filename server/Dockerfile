FROM ruby:3.3.6

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libsqlite3-dev \
      sqlite3 \
      nodejs \
      npm \
      tzdata && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY server/Gemfile server/Gemfile.lock ./
RUN gem install bundler --no-document && bundle install --jobs 4 --retry 3

COPY server/ ./

COPY server/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ENV RAILS_ENV=production \
    RACK_ENV=production \
    BUNDLE_JOBS=4

EXPOSE 3000

ENTRYPOINT ["entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb", "-b", "tcp://0.0.0.0:3000"]
