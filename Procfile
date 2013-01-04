web:         bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker:      bundle exec sidekiq -C /Users/charlie/Workspace/reader/config/sidekiq.yml
private_pub: rackup -s thin -E production private_pub.ru