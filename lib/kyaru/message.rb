
class Kyaru::Message
  def initialize(bot)
    @bot = bot
  end

  def apply
    message
  end

  def message
    @bot.message(with_text: /Kyaru::Message/) do |event|
      event.respond 'Kyaru::Message'
    end
  end
end

