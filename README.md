## Development

### Environment Variables

This project uses [.env](https://github.com/bkeepers/dotenv) to manage
environment variables. In development you can copy the .env.example file,
which contains instructions on how to set these.:

    cp .env.example .env

## Production

### Environment Variables

The following variables are only required in the production environment:

  - `IP_BLOCKLIST` (optional) A comma-separated list of IP addresses which
    should be blocked (e.g. spambots, attackers). _Example:
    `119.29.55.93,62.210.111.122`_
  - `ROLLBAR_POST_SERVER_ITEM_ACCESS_TOKEN` [Rollbar](https://rollbar.com/) is
    used for exception reporting. This value can be found in Account Settings
    => Account Access Tokens in your Rollbar account.
