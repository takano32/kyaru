require 'discordrb'
require 'sequel'
require 'yaml'

#
# 設定のロード
#

discord_token = ''
postgres_url  = ''

begin
  # yaml 形式の設定ファイルを読み込む
  config = YAML.load_file("config.yml")
  discord_token = config['discord_token']
  postgres_url  = config['database_url']
rescue
  # 設定ファイルがなかったら環境変数を読み込む
  discord_token = ENV['DISCORD_TOKEN']
  postgres_url  = ENV['DATABASE_URL']
end

bot = Discordrb::Bot.new token: discord_token
db  = Sequel.connect postgres_url

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
# 定型文レスポンス処理の実装
#

# kyaru という発言があったらそのチャンネルで 殺すぞ……！？ と発言する
bot.message(with_text: 'kyaru') do |event|
  event.respond '殺すぞ……！？'
end

# peco という発言があったらそのチャンネルで ヤバいですね☆ と発言する
bot.message(with_text: 'peco') do |event|
  event.respond 'ヤバいですね☆'
end

# hoge という発言があったらそのチャンネルで huga と発言する
bot.message(with_text: 'hoge') do |event|
  event.respond 'fuga'
end

# neko という発言があったらそのチャンネルで あたしの下僕にしてあげよっか……♪ と発言する
bot.message(with_text: 'neko') do |event|
  event.respond 'あたしの下僕にしてあげよっか……♪'
end

# oide という発言があったらそのチャンネルで ちょっとはなれてよ... と発言する
bot.message(with_text: 'oide') do |event|
  event.respond 'ちょっ、はなれてよ殺すわよっ！？'
end

# dubai という発言があったらそのチャンネルで ドバイわよ！ の画像を発言する
bot.message(with_text: 'dubai') do |event|
  event.respond 'https://gyazo.com/4852e37e314b6a18467227bd569283a0'
end

#
# スーモ機能の実装
#

SUUMO=[
  "ダン💥", "ダン💥", "ダン💥",
  "シャーン🎶",
  "スモ🌝", "スモ🌚", "スモ🌝", "スモ🌚", "スモ🌝", "スモ🌚", "ス〜〜〜モ⤴🌝",
  "スモ🌚", "スモ🌝", "スモ🌚", "スモ🌝", "スモ🌚", "スモ🌝", "ス〜〜〜モ⤵🌞",
]
# あ！スーモ！という発言があったらそのチャンネルでスーモっぽい発言をする
bot.message(with_text: 'あ！スーモ！') do |event|
  sumo = SUUMO.shuffle.join('')
  event.respond "#{sumo}"
end

#
# 定期的な処理の実装
#
previous = Time.new
bot.heartbeat do |event|
  # 1時間に一回やりたい処理
  now = Time.new
  if previous.hour < now.hour then
    # #機械 チャンネルで ヤバいわよ！！ 画像を発言する（時報機能）
    bot.send_message('613223157423276053', 'https://gyazo.com/0e4a0ca3bf8bcfd46cd14e078da3fbba')
    # TODO 時給を与える
    previous = now
  end
end


bot.run
