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
RUN gem install bundler:2.4.22
RUN bundle install

# Create log and tmp folders
RUN mkdir -p log tmp/pids tmp/cache tmp/sockets
RUN touch log/development.log

# Precompile assets
RUN bundle exec rake assets:precompile

# Expose port
EXPOSE 3000

# Run the Rails server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
