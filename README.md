Setup
------

Because Swing Out London's source is available on Github, a number of secret items live outside it in environment variables:

### 1. Secret token

First you'll need to generate a secret token (this lives outside the app):

    % rake secret
    % >> ba66a824fff6ff0ea2d8...

Set this to the relevant environment variable - I suggest adding this to your `.rvmrc` if you're using RVM:

    % export SWINGOUTLONDON_SECRET_TOKEN="ba66a824fff6ff0ea2d8..."

You'll also need to set these wherever you're deploying the site. For Heroku you'd run:

    % heroku config:set SWINGOUTLONDON_SECRET_TOKEN="ba66a824fff6ff0ea2d8..."
    
### 2. Twitter api key

In order to use the twitter gem you'll need to [register your app](https://dev.twitter.com/apps/new) and 
set the twitter api keys in your environment. 

    % export TWITTER_CONSUMER_KEY="..."
    % export TWITTER_CONSUMER_SECRET="..."
    % export TWITTER_OAUTH_TOKEN="..."
    % export TWITTER_OAUTH_TOKEN_SECRET="..."
    
As above, you'll also need to set these in your deployment environment
