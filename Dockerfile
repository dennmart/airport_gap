#####################################################################
# Stage 1: Install gems and precompile assets.
#####################################################################
FROM ruby:3.2.2-alpine AS build
WORKDIR /app

ENV RAILS_ENV production
ENV NODE_ENV production

# Set a random secret key base so we can precompile assets.
ENV SECRET_KEY_BASE airport_gap_secret_key_base

# Install necessary packages to build gems and assets.
RUN apk add --no-cache \
  nodejs \
  yarn \
  tzdata \
  postgresql-dev \
  build-base

# Install default gems in vendor/bundle to copy into final image.
COPY Gemfile Gemfile.lock /app/
RUN bundle config set --local path "vendor/bundle" && \
  bundle config set --local without "development test" && \
  bundle install --jobs 4 --retry 3

# Install Node modules to precompile assets.
COPY package.json yarn.lock /app/
RUN yarn install

COPY . /app
RUN bin/rails assets:precompile

#####################################################################
# Stage 2: Copy gems and assets from build stage and finalize image.
#####################################################################
FROM ruby:3.2.2-alpine
WORKDIR /app

ENV RAILS_ENV production

# Install necessary packages to run the app.
# Note that we only need the postgresql package to run the app and keep
# the final image size low, since the postgresql-dev package is only
# needed to build gems.
RUN apk add --no-cache \
  tzdata \
  postgresql

# Make sure Bundler knows we're not using development or test gems, and
# tell it where we're placing
RUN bundle config set --local without "development test" && \
  bundle config set --local path "vendor/bundle"

# Copy the directory from the build stage, which contains the gems and
# precompiled assets so we don't have to run through the process again.
COPY --from=build /app /app/

EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-p", "3000"]
