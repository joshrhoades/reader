God.pid_file_directory = "/tmp/"

God.watch do |w|
  w.group = "reader"
  w.name = "sidekiq"
  w.start = "bundle exec sidekiq -e production -C #{File.expand_path('../../', __FILE__)}/config/sidekiq.yml"
  w.dir = "#{File.expand_path('../../', __FILE__)}"
  w.log = "#{File.expand_path('../../', __FILE__)}/log/sidekiq.log"
  w.keepalive
end

#God.watch do |w|
#  w.group = 'reader'
#  w.name = 'private_pub'
#  w.start = 'rackup -s thin -E production private_pub.ru'
#  w.dir = "#{File.expand_path('../../', __FILE__)}"
#  w.log = "#{File.expand_path('../../', __FILE__)}/log/private_pub.log"
#  w.keepalive
#end
#
#`bundle exec unicorn -c config/unicorn.rb -D`
#`bundle exec rake reader:feeder:run`