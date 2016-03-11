module SquadGoals
  class Team
    extend  SquadGoals::Helpers
    include SquadGoals::Helpers

    attr_reader :id, :name, :slug, :description

    def initialize(hash)
      @id = hash[:id]
      @name = hash[:name]
      @slug = hash[:slug]
      @description = hash[:description]
    end

    def whitelisted?
      Team.whitelist.include?(slug)
    end

    def members
      client_call :team_members, id
    end

    def member?(user)
      user && members.map { |u| u.login.downcase }.include?(user.downcase)
    end

    def add(user)
      response = client_call :add_team_membership, id, user
      dalli.flush
      response
    end

    class << self
      def whitelist
        @whitelist ||= ENV['GITHUB_TEAMS'].split(',').map { |t| t.downcase.strip }
      end
    end
  end
end
