
class Kyaru::Money
  def initialize
    baby = Kyaru::Baby.instance
    @bot = baby.bot
    @db = baby.db
    @money = baby.money
    @stress = baby.stress
  end

  def apply
    message
  end

  def message
    #
    # 所持金関係の実装
    #

    # money という発言があったらそのチャンネルで キャルの現在の所持金 を発言する
    @bot.message(with_text: 'money') do |event|
      event.respond @money.amount.to_s + "ルピ"
    end

    # money+数字 という発言があったらそのチャンネルで キャルの現在の所持金に数字足した数 を発言する
    # /.../ はrubyの正規表現 正規表現に一致したときだけ呼ばれる
    @bot.message(contains: /money\+.[0-9]*/) do |event|
      # /()/  の()の中にマッチした部分を取得してInteger型に変換して変数incrementに代入する
      increment = event.message.content.match(/money\+([0-9].*)/)[1].to_i
      # キャルの現在の所持金を上書き保存する
      @money.set(:amount => @money.amount+increment)
      @money.save
      # キャルの現在の所持金を発言する
      event.respond @money.amount.to_s + "ルピ"
    end

    # money-数字 という発言があったらそのチャンネルで キャルの現在の所持金に数字ひいた数 を発言する
    @bot.message(contains: /money\-.[0-9]*/) do |event|
      decrement = event.message.content.match(/money\-([0-9].*)/)[1].to_i
      @money.set(:amount => @money.amount-decrement)
      @money.save
      event.respond @money.amount.to_s + "ルピ"
    end

    # money:kaizuka という発言があったらそのチャンネルで 貝塚レートで変換したキャルの現在の所持金 を発言する
    @bot.message(with_text: 'money:kaizuka') do |event|
      money_kaizuka = @money.amount * 35
      event.respond money_kaizuka.to_s + "貝塚ルピ"
    end

    # 今日の分くれ という発言があったらキャルの所持金を5000円減らす
    @bot.message(with_text: '今日の分くれ') do |event|
      @money.set(:amount => money.amount - 5000)
      @money.save
      event.respond '今日も楽しんできてね'
    end

  end
end