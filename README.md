# Swing Out London

[Swing Out London](https://www.swingoutlondon.co.uk) is a swing dance listings
website based on a custom CMS for listing links to dance events.

## Setup

### Prerequisites

- [Yarn](https://yarnpkg.com/en/docs/install/) is used in development.
- [Postgres](https://www.postgresql.org/) is the database. If you don't have a
preference for how to run Postgres locally we recommend
[Postgres.app](https://postgresapp.com/).

Other dependencies (including ruby) are listed in
[`.tool-versions`](.tool-versions).

We recommend using [asdf](https://github.com/asdf-vm/asdf) and running `asdf
install` to install these. If you're already managing dependencies in a
different way, ensure that you install the versions listed in
`.tool_versions`.

Set up the app from scratch:

    bin/setup

Run the tests and linters:

    bin/rake

### Local development

See [`Procfile.dev`](Procfile.dev): run each command in its own terminal, or
run them together using the heroku CLI (installed as part of the bundle):

    heroku local -f Procfile.dev

## Environment Variables

This project uses [.env](https://github.com/bkeepers/dotenv) to manage
environment variables.

See [`.env.example`](.env.example) for documentation of environment variables
which can be used in development, some of which are required for the
application to run.

Running `bin/setup` command will copy this file to your `.env` - that's the
file you'll need to modify in order to change these variables. Restart your
server after editing this file.

### Production environment Variables

The following variables are only used in the production environment and so
are not included in the .env.example file:

  - `IP_BLOCKLIST` (optional) A comma-separated list of IP addresses which
    should be blocked (e.g. spambots, attackers). _Example:
    `119.29.55.93,62.210.111.122`_
  - `ROLLBAR_POST_SERVER_ITEM_ACCESS_TOKEN` [Rollbar](https://rollbar.com/) is
    used for exception reporting. This value can be found in Account Settings
    => Account Access Tokens in your Rollbar account.
  - `CANONICAL_HOST` - all variations of the domain will be `301` redirected
    to this - eg. set it to `www.swingoutlondon.co.uk` to have
    `swingoutlondon.co.uk` redirect to www.
