set :application, "swingoutlondon"
set :repository,  "swingout@swingoutlondon.co.uk:git_repos/swingoutlondon.git"
set :domain, "swingoutlondon.co.uk"

set :scm, :git
set :deploy_via, :remote_cache

role :web, "domain"
role :app, "domain"
role :db,  "domain", :primary => true
