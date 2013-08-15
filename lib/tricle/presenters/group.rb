require_relative 'metric'
require_relative 'section'

module Tricle
  module Presenters
    class Group < Section
      attr_reader :metric_presenters, :now, :title

      def initialize(now, title=nil)
        @now = now
        @title = title
        @metric_presenters = []
      end

      def add_metric(klass)
        presenter = Tricle::Presenters::Metric.new(klass, self.now)
        self.metric_presenters << presenter
      end
    end
  end
end
