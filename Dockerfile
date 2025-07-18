FROM ruby:3.4.4

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libvips \
  git \
  curl \
  yarn

# Install Node.js via NodeSource (includes corepack)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs

# Enable corepack and install pnpm
RUN corepack enable && corepack prepare pnpm@8.15.4 --activate

# Set working directory
WORKDIR /chatwoot

# Copy project files
COPY . .

# Create missing log folder to avoid ENOENT
RUN mkdir -p log

# Install bundler version matching Gemfile.lock
RUN gem install bundler:2.5.16

# Install Ruby dependencies
RUN bundle install

# Precompile frontend assets
RUN bundle exec rake assets:precompile

# Expose default Rails port
EXPOSE 3000

# Start the Puma server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
