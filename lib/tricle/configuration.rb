module Tricle
  class Configuration
    attr_accessor :sparklines

    def initialize
      @sparklines = true
    end
  end

  def self.configure
    yield self.configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end
end
