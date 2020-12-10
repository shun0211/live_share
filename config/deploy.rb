# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano

lock '~> 3.14.1'

set :application, 'conefan'
set :repo_url, 'git@github.com:shun0211/live_share.git'

# Default branch is :master
set :branch, 'main'
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/var/www/rails/live_share'

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 2

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, { keys: %w(/root/.ssh/live_share_key_rsa), forward_agent: true, auth_methods: %w(publickey) }
set :ssh_options, {
  # capistranoコマンド実行者の秘密鍵
  port: 22,
  keys: ['~/.ssh/live_share_key_rsa'],
  forward_agent: true,
  auth_methods: ['publickey']
}

append :linked_files, 'config/credentials/production.key'
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')
set :rbenv_type, :user
set :rbenv_ruby, '2.7.1'
set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }
set :unicorn_config_path, -> { "#{current_path}/config/unicorn.conf.rb" }

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end
