module SquadGoals
  class App < Sinatra::Base
    include SquadGoals::Helpers

    set :github_options, scopes: ''

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

    get '/' do
      erb :index, locals: { teams: teams, org_id: org_id }
    end

    get '/join/:team' do
      if team.nil? # invalid team
        status 409
        halt erb :error
      end

      authenticate!
      add!

      erb :success, locals: { team: team, org_id: org_id }
    end
  end
end
