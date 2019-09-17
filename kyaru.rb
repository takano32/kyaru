require 'discordrb'
require 'sequel'
require 'yaml'

#
# 設定のロード
#

discord_token = ''
postgres_url  = ''

config = {}
begin
  # yaml 形式の設定ファイルを読み込む
  yaml = YAML.load_file("config.yml")
  config['discord_token'] = yaml['discord_token']
  config['database_url']  = yaml['database_url']
rescue
  # 設定ファイルがなかったら環境変数を読み込む
  config['discord_token'] = ENV['DISCORD_TOKEN']
  config['database_url']  = ENV['DATABASE_URL']
end

require_relative './lib/kyaru'
baby = Kyaru::Baby.config(config)
baby = Kyaru::Baby.instance

bot = baby.bot
db  = baby.db

# Kyaru::Message
# 定型文の実装をアダプターパターンで押し込める
# require_relative 'lib/kyaru'
message = Kyaru::Message.new(bot)
message.apply

#
# 所持金関係の実装
#

money_primary_key = 1

# キャルの所持金を定義する
class Money < Sequel::Model; end
money = Money[money_primary_key]
unless money
  money = Money.new(:amount => 0)
  money.save
end

# money という発言があったらそのチャンネルで キャルの現在の所持金 を発言する
bot.message(with_text: 'money') do |event|
  money = Money[money_primary_key]
  event.respond money.amount.to_s + "ルピ"
end

# money+数字 という発言があったらそのチャンネルで キャルの現在の所持金に数字足した数 を発言する
# /.../ はrubyの正規表現 正規表現に一致したときだけ呼ばれる
bot.message(contains: /money\+.[0-9]*/) do |event|
  # /()/  の()の中にマッチした部分を取得してInteger型に変換して変数incrementに代入する
  increment = event.message.content.match(/money\+([0-9].*)/)[1].to_i
  # キャルの現在の所持金をデータベースから取得する
  money = Money[money_primary_key]
  # キャルの現在の所持金を上書き保存する
  money.set(:amount => money.amount+increment)
  money.save
  # キャルの現在の所持金を発言する
  event.respond money.amount.to_s + "ルピ"
end

# money-数字 という発言があったらそのチャンネルで キャルの現在の所持金に数字ひいた数 を発言する
bot.message(contains: /money\-.[0-9]*/) do |event|
  decrement = event.message.content.match(/money\-([0-9].*)/)[1].to_i
  money = Money[money_primary_key]
  money.set(:amount => money.amount-decrement)
  money.save
  event.respond money.amount.to_s + "ルピ"
end

# money:kaizuka という発言があったらそのチャンネルで 貝塚レートで変換したキャルの現在の所持金 を発言する
bot.message(with_text: 'money:kaizuka') do |event|
  money = Money[money_primary_key]
  money_kaizuka = money.amount * 35
  event.respond money_kaizuka.to_s + "貝塚ルピ"
end

#
# 定期的な処理の実装
#

previous = Time.new
hourly_wage = 1000
bot.heartbeat do |event|
  # 1時間に一回やりたい処理
  now = Time.new
  if previous.hour < now.hour
    # 9時から18時まで働く
    if 9 < new.hour && now.hour < 18
      # 時給を与える
      money = Money[money_primary_key]
      money.set(:amount => money.amount+hourly_wage)
      money.save
      bot.send_message('613223157423276053', "キャルは時給#{hourly_wage}円を得た")
    end
    previous = now
  end
end

bot.run
