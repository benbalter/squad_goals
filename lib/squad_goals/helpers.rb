module SquadGoals
  module Helpers
    # Call octokit, using memcached response, when available
    def client_call(method, *args)
      puts "METHOD: #{method}"
      puts "ARGS: #{args.join(', ')}"
      key = cache_key(method, args)
      cached = dalli.get(key)
      return cached if cached
      puts 'CACHE MISS'
      response = client.send(method, *args)
      dalli.set(key, response)
      response
    end

    private

    def cache_key(method, *args)
      Digest::SHA1.hexdigest(method.to_s + ': ' + args.join(', '))
    end

    def client
      SquadGoals::App.client
    end

    def dalli
      SquadGoals::App.dalli
    end
  end
end
