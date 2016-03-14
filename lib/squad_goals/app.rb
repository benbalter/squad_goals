module SquadGoals
  class App < Sinatra::Base
    set :github_options, scopes: ''

    MEMCACHE_TTL = 60 * 5 # TTL for caching team info, in seconds

    use Rack::Session::Cookie, http_only: true,
                               secret: ENV['SESSION_SECRET'] || SecureRandom.hex

    ENV['WARDEN_GITHUB_VERIFIER_SECRET'] ||= SecureRandom.hex
    register Sinatra::Auth::Github

    set :views, proc { SquadGoals.views_dir }
    set :root,  proc { SquadGoals.root }
    set :public_folder, proc { SquadGoals.public_dir }

    # require ssl
    configure :production do
      require 'rack-ssl-enforcer'
      use Rack::SslEnforcer
    end

    configure :development do
      Dotenv.load
      Octokit.middleware = Faraday::RackBuilder.new do |builder|
        builder.response :logger
        builder.use Octokit::Response::RaiseError
        builder.adapter Faraday.default_adapter
      end
    end

    configure do
      set :organization, Organization.new(ENV['GITHUB_ORG_ID'])
      set :client, Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])
      set :dalli, Dalli::Client.new((ENV['MEMCACHIER_SERVERS'] || 'localhost:11211').split(','),
                                    username: ENV['MEMCACHIER_USERNAME'],
                                    password: ENV['MEMCACHIER_PASSWORD'],
                                    failover: true,
                                    socket_timeout: 1.5,
                                    socket_failure_delay: 0.2,
                                    exires_in: MEMCACHE_TTL)
    end

    def team_requested
      settings.organization.teams.find { |team| team.slug == params['team'] }
    end

    helpers do
      def avatar(user)
        "<img class=\"avatar avatar-small\" src=\"https://github.com/#{user}.png\" alt=\"user\" width=\"20\" height=\"20\">"
      end
    end

    def locals
      {
        organization: settings.organization,
        teams: settings.organization.teams,
        org_id: settings.organization.login,
        team_requested: team_requested,
        user: (github_user.login if github_user)
      }
    end

    get '/' do
      erb :index, locals: locals
    end

    get '/join/:team' do
      if team_requested.nil? # invalid team
        status 409
        halt erb :error
      end

      authenticate!
      team_requested.add(github_user.login)

      erb :success, locals: locals
    end
  end
end
