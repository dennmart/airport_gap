#####################################################################
# Stage 1: Install gems and precompile assets.
#####################################################################
FROM ruby:3.3.1-alpine AS build
WORKDIR /app

# Set a random secret key base so we can precompile assets.
ENV SECRET_KEY_BASE airport_gap_secret_key_base

# Install necessary packages to build gems and assets.
RUN apk add --no-cache \
  nodejs \
  yarn \
  tzdata \
  postgresql-dev \
  build-base

# Install gems into the vendor/bundle directory in the workspace.
COPY Gemfile Gemfile.lock /app/
RUN bundle config set --local path "vendor/bundle" && \
  bundle install --jobs 4 --retry 3

# Install JavaScript dependencies to precompile assets.
COPY package.json yarn.lock /app/
RUN yarn install

# Precompile app assets as the final step.
COPY . /app/
RUN bin/rails assets:precompile

#####################################################################
# Stage 2: Copy gems and assets from build stage and finalize image.
#####################################################################
FROM ruby:3.3.1-alpine
WORKDIR /app

# Install necessary dependencies required to run the Rails application.
RUN apk add --no-cache \
  tzdata \
  postgresql \
  curl

# Make sure Bundler knows where we're placing our gems coming from
# the build stage.
RUN bundle config set --local path "vendor/bundle"

# Copy everything from the build stage, including gems and precompiled assets.
COPY --from=build /app /app

# Prepare the database before starting the application.
ENTRYPOINT ["/app/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server"]
