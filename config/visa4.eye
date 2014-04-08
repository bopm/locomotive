RAILS_ENV = 'production'

Eye.config do
  logger "/var/www/visa4/log/eye.log"
end

Eye.application "visa4" do
  env "RAILS_ENV" => RAILS_ENV
  working_dir '/var/www/rails/noozoom2/'

  trigger :flapping, :times => 10, :within => 1.minute

  process :puma do
    daemonize true
    pid_file "/var/www/visa4/tmp/pids/puma.pid"
    stdall "/var/www/visa4/log/puma.log"

    start_command "bundle exec puma -C /var/www/visa4/config/puma.rb"
    stop_signals [:TERM, 5.seconds, :KILL]
    restart_command "kill -USR2 {{PID}}"

    restart_grace 10.seconds # just sleep this until process get up status
    # (maybe enought to puma soft restart)

    check :cpu, :every => 30, :below => 80, :times => 3
    check :memory, :every => 30, :below => 70.megabytes, :times => [3,5]
  end
end