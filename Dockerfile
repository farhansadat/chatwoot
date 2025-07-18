FROM ruby:3.4.4

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libvips \
  nodejs \
  yarn \
  git

# Set working directory
WORKDIR /chatwoot

# Copy code
COPY . .

# Install correct bundler version
RUN gem install bundler:2.5.16
RUN bundle _2.5.16_ install

# Precompile assets
RUN bundle exec rake assets:precompile

# Expose port
EXPOSE 3000

# Run the Rails server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
