FROM ruby:3.4.4

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libvips \
  git \
  curl \
  nodejs \
  npm \
  yarn

# Install pnpm safely via npm
RUN npm install -g pnpm@8.15.4

WORKDIR /chatwoot
COPY . .

# Create missing folders to avoid ENOENT errors
RUN mkdir -p log tmp/pids tmp/cache tmp/sockets public/uploads

# Install gems
RUN gem install bundler:2.5.16
RUN bundle install

# Precompile frontend assets
RUN bundle exec rake assets:precompile

# ⚠️ DO NOT RUN db:chatwoot_prepare in Dockerfile (run in console after deploy)
# RUN bundle exec rake db:chatwoot_prepare

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
