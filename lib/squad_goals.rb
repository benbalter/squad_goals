require 'sinatra_auth_github'
require 'octokit'
require 'dotenv'
require 'yaml'
require 'tilt/erb'
require 'dalli'
require 'digest'
require 'squad_goals/version'

module SquadGoals

  autoload :Helpers,      "squad_goals/helpers"
  autoload :App,          "squad_goals/app"
  autoload :Team,         "squad_goals/team"
  autoload :Organization, "squad_goals/organization"

  class << self
    def root
      File.expand_path './squad_goals', File.dirname(__FILE__)
    end

    def views_dir
      @views_dir ||= File.expand_path 'views', SquadGoals.root
    end

    def views_dir=(dir)
      @views_dir = dir
    end

    def public_dir
      @public_dir ||= File.expand_path 'public', SquadGoals.root
    end

    def public_dir=(dir)
      @public_dir = dir
    end
  end
end
