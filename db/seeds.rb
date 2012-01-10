github = Octokit::Client.new

list = []

list.push "Zhengquan"

count = 0

$redis.del "dl"

while count < 1 do
  
  count += 1
  
  puts "Count = #{count}"
  puts "List = #{list.to_s}"
  
  login = list.shift
  
  print "#{login}\t\t\t\t"
  
  if not $redis.sismember("dl", login)
    $redis.sadd("dl", login)
    
    followers = following = repos = cols = []
    langs = {}
    
    followers = github.followers(login)
    following = github.following(login)
    
    github.repos(login).collect{|r| {:fork => r.fork, :name => r.name}}.each do |repo|
      if not repo[:fork]
        langs.merge! github.languages("#{login}/#{repo[:name]}")
        cols += github.collaborators("#{login}/#{repo[:name]}").map(&:login)
      end
      repos.push repo[:name]
    end
    
    # write into redis
    followers.each  {|user|  $redis.sadd("user:#{login}:fers", user)}
    following.each  {|user|  $redis.sadd("user:#{login}:fing", user)}
    langs.keys.each {|lang|  $redis.sadd("user:#{login}:lang", lang)}
    repos.each      {|repo|  $redis.sadd("user:#{login}:repo", repo)}
    cols.uniq.each  {|user|  $redis.sadd("user:#{login}:cols", user)}
    
    # remove self from collaborators
    $redis.srem("user:#{login}:cols", login)
    
    # take nodes to dl
    list += (followers + following).uniq
    
    print "[OK]\n"
  end
end
