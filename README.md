## Setup

### Prerequisites

[Yarn](https://yarnpkg.com/en/docs/install/) is used in development.

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

## Environment Variables

This project uses [.env](https://github.com/bkeepers/dotenv) to manage
environment variables.

The `bin/setup` command creates a starting file which you will need to
configure in order for some parts of the application to work in development.
That file contains instructions on how to set those variables.

### Production environment Variables

The following variables are only used in the production environment and so
are not included in the .env.example file:

  - `IP_BLOCKLIST` (optional) A comma-separated list of IP addresses which
    should be blocked (e.g. spambots, attackers). _Example:
    `119.29.55.93,62.210.111.122`_
  - `ROLLBAR_POST_SERVER_ITEM_ACCESS_TOKEN` [Rollbar](https://rollbar.com/) is
    used for exception reporting. This value can be found in Account Settings
    => Account Access Tokens in your Rollbar account.
