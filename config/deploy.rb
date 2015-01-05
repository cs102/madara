require "bundler/capistrano"
default_run_options[:shell] = '/bin/bash --login' 
#require 'hipchat/capistrano'
#update email 
#set :hipchat_token, "jGfVLjSg2hLBD0szNhdEk3iGGF8rvKPsxdPiC3wQ"
#set :hipchat_room_name, "leaf4"
#set :hipchat_announce, true # notify users?

##comments
server "littlebookmarks.com", :web, :app, :db, primary: true

set :domain, 'littlebookmarks.com'
set :application, 'madara'
set :user, 'deploy'
set :deploy_to, "/home/#{user}/#{application}"
set :deploy_via, :remote_cache
set :copy_exclude, [".git", "spec"]
set :use_sudo, false

set :scm, "git"
#set :repository, "#{user}@#{domain}:git/#{application}.git"
set :repository, "git@github.com:cs102/#{application}.git"
set :branch, "master"
set :shared_children, shared_children + %w{public/uploads}

default_run_options[:pty] = true
ssh_options[:forward_agent] = true


after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "/etc/init.d/unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the database config files in #{shared_path}."
    puts "---"
    put File.read("config/secrets.example.yml"), "#{shared_path}/config/secrets.yml"
    puts "Please run RAILS_ENV=production rake secret"
    puts "Now edit the secrets files in #{shared_path}."
    put File.read("config/application.example.yml"), "#{shared_path}/config/application.yml"
    puts "---"
    puts "Now edit the application yml file in #{shared_path}."

  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"

  end
  after "deploy:finalize_update", "deploy:symlink_config"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end