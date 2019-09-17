
require 'singleton'

class Kyaru::Baby
  include Singleton

  def self.config(config)
    @@config = config
  end

  def initialize
  end
end

