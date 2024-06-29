![Airport Gap](https://airportgap.com/images/airport_gap_logo.png)

Airport Gap is a [RESTful API](https://www.restapitutorial.com/) to help you improve your API automation testing skills. It provides access to a database of airports, calculate distances between airports, and allows you to save your favorite airports.

You can create a free Airport Gap account at https://airportgap.com/.

Airport data is provided by [OpenFlights.org](https://openflights.org/data.php) under the [Open Database License](http://opendatacommons.org/licenses/odbl/1.0/").

Airport Gap is provided by [Dev Tester](https://dev-tester.com/) - articles and tips to help you improve your test automation skills as a developer.

## QuickStart: Setting up and running the application locally

Airport Gap is a Rails 7 application. You need the following dependencies installed to run the application:

- [Ruby](https://www.ruby-lang.org/) (current version: 3.3.3)
- [Bundler](https://bundler.io/) (current stable 2.x version)
- [Yarn](https://yarnpkg.com/) (current stable version)
- [PostgreSQL](https://www.postgresql.org/) (version 12.0 or greater)
- [Foreman](https://github.com/ddollar/foreman) (current version)

Once the dependencies are installed, run `./bin/setup` to set up the application. The script will perform the following steps automatically:

- Install Ruby dependencies (`bundle install`)
- Install Javascript dependencies (`yarn install`)
- Set up the database with seed data (`rails db:prepare`)

When everything is installed, run `./bin/dev` to start all the required processes to build the CSS and JavaScript and start the application server. The application will be accessible at http://localhost:5000/.

## Automated tests

The Airport Gap application has a suite of automated tests to help during development.

Unit tests are set up with [RSpec](https://rspec.info/). To run the tests, set up the application's Ruby dependencies (`bundle install`) and a test database, and run `rails spec`.

End-to-end tests for the API are covered with [APId](https://github.com/getapid/apid). To run the tests, [download the APId binary](https://github.com/getapid/apid/releases), set it up in your `PATH`, and run `apid check`. The tests require the following environment variables:

- `AIRPORT_GAP_API_URL`: The URL of the API endpoints. If you're running the application locally, the URL is `http://localhost:5000/api`.
- `AIRPORT_GAP_EMAIL`: The email address for a valid Airport Gap account in the application.
- `AIRPORT_GAP_PASSWORD`: The password for the Airport Gap account in the application.

## Docker

A [Dockerfile](/Dockerfile) is provided to run the application in a [Docker](https://www.docker.com/) container. You can build the container locally with `docker build -t airport-gap .`.

To run Airport Gap using a built Docker image, you can use [Docker Compose](https://docs.docker.com/compose/) to spin up the application and its required services. The example `docker-compose.yml` file below starts a PostgreSQL database, a Redis server, and the Airport Gap application.

```yml
version: "3.9"
services:
  web:
    image: airportgap:latest
    ports:
      - 3000:3000
    links:
      - postgres
      - redis
    environment:
      - RAILS_ENV=production
      - RACK_ENV=production
      - PGHOST=postgres
      - PGUSER=airport_gap_user
      - PGPASSWORD=airport_gap
      - DATABASE_URL=postgres://airport_gap_user:airport_gap@postgres:5432/airport_gap_db
      - REDIS_URL=redis://redis:6379/0
      - RAILS_SERVE_STATIC_FILES=true
      - RAILS_LOG_TO_STDOUT=true
      - SECRET_KEY_BASE=dsjkfhsdjfhsdjk
    depends_on:
      - postgres
      - redis
  postgres:
    image: postgres:15.2
    expose:
      - 5432
    environment:
      - POSTGRES_DB=airport_gap_db
      - POSTGRES_USER=airport_gap_user
      - POSTGRES_PASSWORD=airport_gap
  redis:
    image: redis:7.0.11
    expose:
      - 6379
```

To seed the database with data, run `docker-compose exec web bundle exec rails db:setup`. You can then access the application at http://localhost:3000/.

## Kamal

This repo contains the necessary configuration for [Kamal deployments](https://kamal-deploy.org/). The [config/deploy.yml](/config/deploy.yml) file contains an example configuration file for deploying Airport Gap to a remote server.

For more details on deploying a Rails application using Kamal using Airport Gap as an example, check out the video ["Rails Deployments Made Easy with Terraform and Kamal"](https://www.youtube.com/watch?v=uVGo7eZr6wU) on YouTube.
