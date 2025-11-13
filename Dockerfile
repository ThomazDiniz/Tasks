FROM ruby:3.2.0

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client sqlite3 build-essential

WORKDIR /app

COPY Gemfile* ./
RUN bundle install

COPY . .

# Make sure bin files are executable
RUN chmod +x bin/* 2>/dev/null || true

# Make entrypoint script executable
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

