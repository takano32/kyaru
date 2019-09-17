
require 'singleton'

class Kyaru::Baby
  include Singleton

  def self.config(config)
    @@config = config
  end

  attr_reader :bot, :db
  def initialize(config = @@config)
    @config = config
    @bot = Discordrb::Bot.new token: @config['discord_token']
    @db = Sequel.connect @config['database_url']
  end
end

