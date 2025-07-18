# Use correct Ruby version
FROM ruby:3.4.4

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libvips \
  git \
  curl \
  nodejs \
  npm \
  yarn

# Install pnpm manually via npm (no corepack needed)
RUN npm install -g pnpm@8.15.4

# Set working directory
WORKDIR /chatwoot

# Copy project files
COPY . .

# Install the correct Bundler version
RUN gem install bundler:2.5.16
RUN bundle install

# Precompile Rails assets
RUN bundle exec rake assets:precompile

# TEMP: Set up DB (can be removed after first launch)
RUN bundle exec rake db:chatwoot_prepare

# Expose port used by Puma
EXPOSE 3000

# Start Chatwoot server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
