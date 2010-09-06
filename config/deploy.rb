set :application, "swingoutlondonlive"
set :repository,  "swingout@swingoutlondon.co.uk:git_repos/swingoutlondon.git"
set :domain, "swingoutlondon.co.uk"

set :scm, :git
set :deploy_via, :remote_cache
set :use_sudo, false
set :user, "swingout"

set :deploy_to, "/home/#{user}/#{application}"

role :web, domain
role :app, domain
role :db,  domain, :primary => true

set :keep_releases, 4
after 'deploy:update', 'deploy:cleanup'



