FROM ruby:3.2-slim
WORKDIR /app

COPY . /app

RUN gem install bundler && bundle install --jobs 4

ENTRYPOINT ["ruby", "bin/cash_register.rb"]

CMD []