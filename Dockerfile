FROM ruby:3.4.4

# Use alternative mirrors and install dependencies
RUN apt-get update -o Acquire::ForceIPv4=true && apt-get install -y \
  build-essential \
  libpq-dev \
  libvips-dev \
  git \
  curl \
  ca-certificates

# Install Node.js 18, npm, yarn using NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g yarn pnpm@8.15.4

# Set working directory
WORKDIR /chatwoot
COPY . .

# Create missing folders
RUN mkdir -p log tmp/pids tmp/cache tmp/sockets public/uploads

# Install bundler and dependencies
RUN gem install bundler:2.5.16
RUN bundle install

# Precompile assets
RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
