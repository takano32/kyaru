
class Kyaru::Message
  def initialize(bot)
    @bot = bot
  end

  def apply
    message
    message_suumo
  end

  def message
    #
    # 定型文レスポンス処理の実装
    #

    # kyaru という発言があったらそのチャンネルで 殺すぞ……！？ と発言する
    @bot.message(with_text: 'kyaru') do |event|
      event.respond '殺すぞ……！？'
    end

    # peco という発言があったらそのチャンネルで ヤバいですね☆ と発言する
    @bot.message(with_text: 'peco') do |event|
      event.respond 'ヤバいですね☆'
    end

    # hoge という発言があったらそのチャンネルで huga と発言する
    @bot.message(with_text: 'hoge') do |event|
      event.respond 'fuga'
    end

    # neko という発言があったらそのチャンネルで あたしの下僕にしてあげよっか……♪ と発言する
    @bot.message(with_text: 'neko') do |event|
      event.respond 'あたしの下僕にしてあげよっか……♪'
    end

    # oide という発言があったらそのチャンネルで ちょっとはなれてよ... と発言する
    @bot.message(with_text: 'oide') do |event|
      event.respond 'ちょっ、はなれてよ殺すわよっ！？'
    end

    # dubai という発言があったらそのチャンネルで ドバイわよ！ の画像を発言する
    @bot.message(with_text: 'dubai') do |event|
      event.respond 'https://gyazo.com/4852e37e314b6a18467227bd569283a0'
    end

  end

  def message_suumo
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
    @bot.message(with_text: 'あ！スーモ！') do |event|
      sumo = SUUMO.shuffle.join('')
      event.respond "#{sumo}"
    end
  end
end

