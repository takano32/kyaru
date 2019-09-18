
require 'singleton'

class Kyaru::Baby
  include Singleton

  def self.config(config)
    @@config = config
  end

  attr_reader :bot, :db, :money, :stress
  def initialize(config = @@config)
    @config = config
    @bot = Discordrb::Bot.new token: @config['discord_token']
    @db = Sequel.connect @config['database_url']
    # 所持金を定義する
    instance_eval %{
      class Kyaru::Baby::Money < Sequel::Model; end
    }
    # 所持金をデータベースから取得する
    @money = Kyaru::Baby::Money[1]
    unless @money
      @money = Kyaru::Baby::Money.new(:amount => 0)
      @money.save
    end
    # ストレスを定義する
    instance_eval %{
      class Kyaru::Baby::Stress < Sequel::Model; end
    }
    @stress = Kyaru::Baby::Stress[1]
    unless @stress
      @stress = Kyaru::Baby::Stress.new(:amount => 0)
      @stress.save
    end
  end
end

