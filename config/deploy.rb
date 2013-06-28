require 'rvm/capistrano'

set :application, "myusa_discovery_bar"
set :repository,  "git@github.com:GSA-OCSIT/mygov-bar.git"
set :user, "ubuntu"
set :rvm_type, :user
set :deploy_to, "/var/www/myusa_discovery_bar"
set :deploy_via, :remote_cache
set :branch, ENV['BRANCH'] || 'gh-pages'
set :config, ENV['BRANCH'] ? "--config _#{ENV['BRANCH']}_config.yml" : ''
set :ssh_options, {forward_agent:true}
set :keep_releases, 3

# Set for the password prompt
# https://help.github.com/articles/deploying-with-capistrano
default_run_options[:pty] = true
role :web, "23.21.244.197"

namespace :deploy do
  # override finalize_update task since we're not using rails
  task :finalize_update, :except => { :no_release => true } do
    escaped_release = latest_release.to_s.shellescape
    commands = []
    commands << "chmod -R -- g+w #{escaped_release}" if fetch(:group_writable, true)

    # mkdir -p is making sure that the directories are there for some SCM's that don't
    # save empty folders
    shared_children.map do |dir|
      d = dir.shellescape
      if (dir.rindex('/')) then
        commands += ["rm -rf -- #{escaped_release}/#{d}",
                     "mkdir -p -- #{escaped_release}/#{dir.slice(0..(dir.rindex('/'))).shellescape}"]
      else
        commands << "rm -rf -- #{escaped_release}/#{d}"
      end
      commands << "ln -s -- #{shared_path}/#{dir.split('/').last.shellescape} #{escaped_release}/#{d}"
    end

    run commands.join(' && ') if commands.any?
  end
  
  desc "Upload custom (branch-based) config to remote server(s)."
  task :upload_custom_config do
    top.upload("_deploy_uat_apache_config.yml", "#{current_path}/", via: :scp)
  end
  
  desc "chown & chmod to www"
  task :chown do
    sudo "chown -R ubuntu #{deploy_to}"
    sudo "chmod -R 775 #{deploy_to}"
  end

  desc "start the server"
  task :start do
    run "cd #{deploy_to}/current;jekyll build #{config}"
  end

  desc "restart the server"
  task :restart do
    stop
    start
  end
end

after 'deploy:setup', 'deploy:chown'
after 'deploy:update', 'deploy:upload_custom_config'