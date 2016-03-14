module SquadGoals
  class Organization
    include SquadGoals::Helpers

    attr_reader :login

    def initialize(login)
      @login = login.downcase.strip
    end

    def name
      meta.name || "@#{meta.login}"
    end

    def teams
      client_call(:organization_teams, login).map do |team|
        Team.new(team)
      end.select(&:whitelisted?)
    end

    def member?(user)
      client_call :organization_member?, login, user
    end

    private

    def meta
      @meta ||= client_call :organization, login
    end
  end
end
