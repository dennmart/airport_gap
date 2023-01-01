![Airport Gap](https://airportgap.dev-tester.com/images/airport_gap_logo.png)

Airport Gap is a [RESTful API](https://www.restapitutorial.com/) to help you improve your API automation testing skills. It provides access to a database of airports, calculate distances between airports, and allows you to save your favorite airports.

You can create a free Airport Gap account at https://airportgap.dev-tester.com/.

Airport data is provided by [OpenFlights.org](https://openflights.org/data.html) under the [Open Database License](http://opendatacommons.org/licenses/odbl/1.0/").

Airport Gap is provided by [Dev Tester](https://dev-tester.com/) - articles and tips to help you improve your test automation skills as a developer.

## QuickStart: Setting up and running the application locally

Airport Gap is a Rails 7 application. You need the following dependencies installed to run the application:

- [Ruby](https://www.ruby-lang.org/) (current version: 3.2.0)
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
