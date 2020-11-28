#サーバ上でのアプリケーションコードが設置されているディレクトリを変数に入れておく
app_path = File.expand_path('../../../', __FILE__)


# $worker  = 2
# $timeout = 30
# $app_dir = "/var/www/rails/live_share/current"
# $listen  = File.expand_path 'shared/tmp/sockets/.unicorn.sock', $app_dir
# $pid     = File.expand_path 'shared/tmp/pids/unicorn.pid', $app_dir
# $std_log = File.expand_path 'shared/log/unicorn.log', $app_dir
# set config
worker_processes 2
working_directory "#{app_path}/current"
stderr_path "#{app_path}/shared/log/unicorn.stderr.log"
stdout_path "#{app_path}/shared/log/unicorn.stdout.log"
timeout 30
listen "#{app_path}/shared/tmp/sockets/unicorn.sock"
pid "#{app_path}/shared/tmp/pids/unicorn.pid"
# loading booster
preload_app true

GC.respond_to?(:copy_on_write_friendly=) && GC.copy_on_write_friendly = true

check_client_connection false

run_once = true

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_path}/current/Gemfile"
end

before_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!

  if run_once
    run_once = false # prevent from firing again
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH

    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end
