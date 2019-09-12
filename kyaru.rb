require 'discordrb'
require 'yaml'

discord_token = ''

begin
  # yaml 形式の設定ファイルを読み込む
  config = YAML.load_file("config.yml")
  discord_token = config['discord_token']
rescue
  # 設定ファイルがなかったら環境変数を読み込む
    discord_token = ENV['DISCORD_TOKEN']
end

puts discord_token

bot = Discordrb::Bot.new token: discord_token

# kyaru という発言があったらそのチャンネルで 殺すぞ……！？ と発言する
bot.message(with_text: 'kyaru') do |event|
  event.respond '殺すぞ……！？'
end

# peco という発言があったらそのチャンネルで ヤバいですね☆ と発言する
bot.message(with_text: 'peco') do |event|
  event.respond 'ヤバいですね☆'
end

bot.run
