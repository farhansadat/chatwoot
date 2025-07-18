# Use the correct Ruby version
FROM ruby:3.4.4

# Install required dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  libvips \
  git \
  curl \
  nodejs \
  yarn

# Enable corepack and install pnpm (node is already included above)
RUN corepack enable && corepack prepare pnpm@8.15.4 --activate

# Set working directory
WORKDIR /chatwoot

# Copy code into the container
COPY . .

# Install the correct Bundler version
RUN gem install bundler:2.5.16
RUN bundle install

# Precompile assets
RUN bundle exec rake assets:precompile

# ❗ Temporary: Run DB setup (migrate + seed)
RUN bundle exec rake db:chatwoot_prepare

# Expose port that Puma uses
EXPOSE 3000

# Start Chatwoot server via Puma
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
