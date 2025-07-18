# Use the latest working Ruby version for Chatwoot
FROM ruby:3.4.4

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libvips \
  git \
  curl \
  nodejs \
  npm \
  yarn

# Install pnpm safely via npm (skip corepack issues)
RUN npm install -g pnpm@8.15.4

# Set working directory
WORKDIR /chatwoot

# Copy entire app
COPY . .

# Ensure log/tmp/upload folders exist
RUN mkdir -p log tmp/pids tmp/cache tmp/sockets public/uploads

# Install correct Bundler version & gems
RUN gem install bundler:2.5.16
RUN bundle install

# Precompile assets
RUN bundle exec rake assets:precompile

# Initialize the database (only for first deploy, can remove later)
RUN bundle exec rake db:chatwoot_prepare

# Expose port for Puma
EXPOSE 3000

# Start the Puma server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
