![Airport Gap](https://airportgap.dev-tester.com/images/airport_gap_logo.png)

Airport Gap is a [RESTful API](https://www.restapitutorial.com/) to help you improve your API automation testing skills. It provides access to a database of airports, calculate distances between airports, and allows you to save your favorite airports.

You can create a free Airport Gap account at https://airportgap.dev-tester.com/.

Airport data is provided by [OpenFlights.org](https://openflights.org/data.html) under the [Open Database License](http://opendatacommons.org/licenses/odbl/1.0/").

Airport Gap is provided by [Dev Tester](https://dev-tester.com/) - articles and tips to help you improve your test automation skills as a developer.

## QuickStart: Setting up and running the application locally

Airport Gap is a Rails 6.0 application. You need the following dependencies installed to run the application:

- [Ruby](https://www.ruby-lang.org/) (current version: 2.6.5)
- [Bundler](https://bundler.io/) (current version: 2.0.2)
- [Yarn](https://yarnpkg.com/) (current stable version)
- [PostgreSQL](https://www.postgresql.org/) (version 10.0 or greater)

Once the dependencies are installed, run the `bin/setup` script to set up the application. The script will perform the following steps automatically:

- Install Ruby dependencies (`bundle install`)
- Install Javascript dependencies (`yarn install`)
- Set up the database with seed data (`rails db:prepare`)

When everything is installed, run the Rails server locally with `rails s`. The application will be accessible at http://localhost:3000/.