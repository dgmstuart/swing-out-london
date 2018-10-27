Setup
------

Because Swing Out London's source is available on Github, a number of secret items live outside it in environment variables:

### 1. Twitter api key

In order to use the twitter gem you'll need to [register your app](https://dev.twitter.com/apps/new) and
set the twitter api keys in your environment.

    % export TWITTER_CONSUMER_KEY="..."
    % export TWITTER_CONSUMER_SECRET="..."
    % export TWITTER_OAUTH_TOKEN="..."
    % export TWITTER_OAUTH_TOKEN_SECRET="..."

As above, you'll also need to set these in your deployment environment
