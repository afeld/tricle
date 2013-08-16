require_relative 'metric'
require_relative 'section'

module Tricle
  module Presenters
    class Group < Section
      attr_reader :metric_presenters, :title

      def initialize(now, title=nil)
        @title = title
        @metric_presenters = []
        super(now)
      end

      def add_metric(klass)
        presenter = Tricle::Presenters::Metric.new(klass, self.now)
        self.metric_presenters << presenter
      end
    end
  end
end
