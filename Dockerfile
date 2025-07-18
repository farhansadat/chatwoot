FROM ruby:3.4.4

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libvips \
  git \
  curl

# Install Node.js 18 via NodeSource (includes corepack)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs

# Enable corepack and install pnpm & yarn
RUN corepack enable && corepack prepare pnpm@8.15.4 --activate && corepack prepare yarn@1.22.19 --activate

# Set working directory
WORKDIR /chatwoot

# Copy code
COPY . .

# Create log directory
RUN mkdir -p log

# Install correct bundler version
RUN gem install bundler:2.5.16

# Install Ruby dependencies
RUN bundle install

# Precompile frontend assets
RUN bundle exec rake assets:precompile
RUN mkdir -p /chatwoot/log

# Expose port
EXPOSE 3000

# Start the Rails app
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
