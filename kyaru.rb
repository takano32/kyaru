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

bot = Discordrb::Bot.new token: discord_token

# kyaru という発言があったらそのチャンネルで 殺すぞ……！？ と発言する
bot.message(with_text: 'kyaru') do |event|
  event.respond '殺すぞ……！？'
end

# peco という発言があったらそのチャンネルで ヤバいですね☆ と発言する
bot.message(with_text: 'peco') do |event|
  event.respond 'ヤバいですね☆'
end

# neko という発言があったらそのチャンネルで あたしの下僕にしてあげよっか……♪ と発言する
bot.message(with_text: 'neko') do |event|
  event.respond 'あたしの下僕にしてあげよっか……♪'
end

# 定期的な処理をする部分
previous = Time.new
bot.heartbeat do |event|
  # 1時間に一回 #機械 チャンネルで ヤバいわよ！！ 画像を発言する（時報機能）
  now = Time.new
  if previous.hour < now.hour then
    bot.send_message('613223157423276053', 'https://gyazo.com/0e4a0ca3bf8bcfd46cd14e078da3fbba')
    previous = now
  end
end

bot.run

# 危ないコメント   
