require "redis"
require "redis-namespace"
require 'redis/objects'

$redis = Redis.new(:host => "localhost", :port => 6379)

Redis::Objects.redis = $redis

Resque.redis = $redis

Resque.redis.namespace = "resque:segue"
