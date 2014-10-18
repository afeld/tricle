module Tricle
  class Time
    attr_reader :time

    def initialize(time=nil)
      @time = time || ::Time.now
    end

    def day_of_week
      self.time.strftime('%A').downcase.to_sym
    end

    def day_of_month
      self.time.strftime('%-d').to_i
    end

    def beginning_of_week?
      self.day_of_week == self.class.beginning_of_week
    end

    def beginning_of_month?
      self.day_of_month == 1
    end

    ## delegate methods ##

    def beginning_of_day
      self.time.beginning_of_day
    end

    def beginning_of_week
      self.time.beginning_of_week
    end

    ######################

    class << self
      def beginning_of_week
        if Date.respond_to?(:beginning_of_week)
          # Rails >= 4.0.2
          # http://apidock.com/rails/v4.0.2/Date/beginning_of_week/class
          Date.beginning_of_week
        else
          :monday
        end
      end
    end
  end
end
