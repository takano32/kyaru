class Kyaru::Heartbeat
  def initialize
    baby = Kyaru::Baby.instance
    @bot = baby.bot
    @db = baby.db
    @money = Kyaru::Baby::Money[1]
    @stress = Kyaru::Baby::Stress[1]
  end

  def apply
    heartbeat
  end

  def heartbeat
    #
    # 定期的な処理の実装
    #

    previous = Time.new - (60*60)
    hourly_wage = 1000
    @bot.heartbeat do |event|
      # 1時間に一回やりたい処理
      now = Time.new
      if previous.hour < now.hour
        # 9時から22時まで働く
        if 9 < now.hour && now.hour < 22
          # 時給を与える
          @money.set(:amount => @money.amount+hourly_wage)
          @money.save
          @bot.send_message('613223157423276053', "キャルは時給#{hourly_wage}円を得た")
        end
        previous = now
      end
    end
  end
end