require 'discordrb'
require 'yaml'

config = YAML.load_file("config.yml")

bot = Discordrb::Bot.new token: config['discord_token']

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
  event.respond 'huga'
end

bot.run
