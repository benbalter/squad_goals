module SquadGoals
  module Helpers

    def teams
      @teams ||= begin
        teams = client.organization_teams(org_id)
        teams.select { |team| team_whitelist.include? team.slug }
      end
    end

    private

    def team_whitelist
      ENV['GITHUB_TEAMS'].split(",")
    end

    def client
      @client ||= Octokit::Client.new access_token: ENV['GITHUB_TOKEN']
    end

    def org_id
      ENV['GITHUB_ORG_ID']
    end

    def team
      teams.find { |team| team.slug == params["team"] }
    end

    def add!
      client.add_team_membership team.id, github_user.login
    end
  end
end
