FROM ruby:3.4.4

# Install OS dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libvips \
  curl \
  git \
  nodejs \
  yarn

# Enable corepack (included with Node.js) and install pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Set working directory
WORKDIR /chatwoot

# Copy application code
COPY . .

# Fix log dir error
RUN mkdir -p log

# Install correct bundler version
RUN gem install bundler:2.5.16

# Install Ruby gems
RUN bundle install

# Precompile assets
RUN bundle exec rake assets:precompile

# Expose default port
EXPOSE 3000

# Start Chatwoot server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
