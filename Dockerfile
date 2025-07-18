FROM ruby:3.4.4

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libvips \
  nodejs \
  yarn \
  git \
  curl

# Set working directory
WORKDIR /chatwoot

# Copy code
COPY . .

# Fix missing log dir
RUN mkdir -p log

# Use exact Bundler version that matches Gemfile.lock
RUN gem install bundler:2.5.16

# Install gems
RUN bundle install

# Precompile assets
RUN bundle exec rake assets:precompile

# Expose port
EXPOSE 3000

# Run the Rails server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
