require 'discordrb'
require 'sequel'
require 'yaml'

#
# 設定のロード
#

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

# キャルを初期化する
require_relative './lib/kyaru'
Kyaru::Baby.config(config)
baby = Kyaru::Baby.instance

bot = baby.bot
db  = baby.db

# Kyaru::Message
# 定型文の実装をアダプターパターンで押し込める
message = Kyaru::Message.new
message.apply

# Kyaru::Heatbeat
# 定期的な処理をアダプターパターンで押し込める
heatbeat = Kyaru::Heartbeat.new
heatbeat.apply

# Kyaru::Money
# 所持金関係の処理をアダプターパターンで押し込める
money = Kyaru::Money.new
money.apply


bot.run
