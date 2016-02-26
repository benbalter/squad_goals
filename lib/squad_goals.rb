require 'sinatra_auth_github'
require 'octokit'
require 'dotenv'
require 'yaml'
require 'tilt/erb'

require 'squad_goals/version'
require 'squad_goals/helpers'
require 'squad_goals/app'

module SquadGoals
  def self.root
    File.expand_path './squad_goals', File.dirname(__FILE__)
  end

  def self.views_dir
    @views_dir ||= File.expand_path 'views', SquadGoals.root
  end

  def self.views_dir=(dir)
    @views_dir = dir
  end

  def self.public_dir
    @public_dir ||= File.expand_path 'public', SquadGoals.root
  end

  def self.public_dir=(dir)
    @public_dir = dir
  end
end

unless SquadGoals::App.production?
  Dotenv.load
  stack = Faraday::RackBuilder.new do |builder|
    builder.response :logger
    builder.use Octokit::Response::RaiseError
    builder.adapter Faraday.default_adapter
  end
  Octokit.middleware = stack
end
