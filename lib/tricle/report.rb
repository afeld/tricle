module Tricle
  class Report
    attr_reader :metric_instances

    def initialize
      @metric_instances = self.metrics.map{|m| m.new }
    end


    def metrics
      raise Tricle::AbstractMethodError.new
    end
  end
end
