#####################################################################
# Stage 1: Install gems and precompile assets.
#####################################################################
FROM ruby:3.2.2-slim AS build
WORKDIR /app

ENV RAILS_ENV production
ENV NODE_ENV production

# Set a random secret key base so we can precompile assets.
ENV SECRET_KEY_BASE airport_gap_secret_key_base

# Install packages to set up Node.js and Yarn repos.
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  curl \
  gnupg

# Set up Node.js and Yarn repos.
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install necessary packages to build gems and assets.
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  nodejs \
  yarn \
  build-essential \
  libpq-dev

# Install default gems in vendor/bundle to copy into final image.
COPY Gemfile Gemfile.lock /app/
RUN bundle config set --local path "vendor/bundle" && \
  bundle config set --local without "development test" && \
  bundle install --jobs 4 --retry 3

# Install Node modules to precompile assets.
COPY package.json yarn.lock /app/
RUN yarn install

# Precompile app assets as the final build step.
COPY . /app/
RUN bin/rails assets:precompile

#####################################################################
# Stage 2: Copy gems and assets from build stage and finalize image.
#####################################################################
FROM ruby:3.2.2-slim
WORKDIR /app

ENV RAILS_ENV production

# Install necessary packages to run the app. We only need the libpq-dev
#  package to run the app since we don't need to build any other gems.
RUN apt-get update && \
  apt-get install -y --no-install-recommends libpq-dev

# Make sure Bundler knows we're not using development or test gems, and
# tell it where we're placing our gems coming from the build stage.
RUN bundle config set --local without "development test" && \
  bundle config set --local path "vendor/bundle"

# Copy everything from the build stage, including gems and precompiled assets.
COPY --from=build /app /app/

EXPOSE 3000
CMD ["bundle", "exec", "rails", "s", "-p", "3000"]
