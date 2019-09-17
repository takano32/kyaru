
require 'singleton'

class Kyaru::Baby
  include Singleton

  def self.config(config)
    @@config = config
  end

  attr_reader :bot, :db
  def initialize(config = @@config)
    @config = config
    initialize_bot
    initialize_db
  end

  def initialize_bot
    @bot = Discordrb::Bot.new token: @config['discord_token']
  end

  def initialize_db
    @db = Sequel.connect @config['database_url']
  end
end

