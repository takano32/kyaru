class Kyaru::Heartbeat
  def initialize
    baby = Kyaru::Baby.instance
    @bot = baby.bot
    @db = baby.db
    @money = baby.money
    @stress = baby.stress
  end

  def apply
    heartbeat
  end

  def heartbeat
    #
    # 定期的な処理の実装
    #

    room = '613223157423276053'

    # Heroku上のTimeはUTCなので+9時間する
    one_hour_ago = Time.now - (60 * 60)
    one_hour_ago = one_hour_ago.getlocal('+09:00')

    hourly_wage = 1000
    @bot.heartbeat do |event|
      # 1時間に1回やりたい処理

      # Heroku上のTimeはUTCなので+9時間する
      now = Time.new + (60 * 60)
      now = now.getlocal('+09:00')

      if one_hour_ago.hour < now.hour
        @bot.send_message(room, "#{now.hour}時になった")

        # 9時から22時まで働く
        if 9 < now.hour && now.hour < 22
          @bot.send_message(room, "キャルは働いている")

          # 時給を与える
          @money.set(:amount => @money.amount+hourly_wage)
          @money.save
          @bot.send_message(room, "キャルは時給#{hourly_wage}円を得た")

          # 働くとストレスが溜まる
          @stress.set(:amount => @stress.amount+1)
          @stress.save
          @bot.send_message(room, "キャルは#{@stress.amount}ストレスをためている")
        end

        # 23時から8時まで寝る
        if 23 < now.hour || now.hour < 8
          @bot.send_message(room, "キャルは寝ている")

          # 寝るとストレスが減る
          @stress.set(:amount => @stress.amount-1)
          @stress.save
          @bot.send_message(room, "キャルのストレスが#{@stress.amount}になった")
        end
        one_hour_ago = now
      end
    end
  end
end
