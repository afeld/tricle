module Tricle
  class Group
    attr_reader :metric_instances, :title

    def initialize(title=nil)
      @title = title
      @metric_instances = []
    end

    def add_metric(klass)
      self.metric_instances << klass.new
    end
  end
end
