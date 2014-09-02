require_relative 'section'

module Tricle
  module Presenters
    class Group < Section
      attr_reader :metrics, :title

      def initialize(title=nil)
        @title = title
        @metrics = []
      end

      def add_metric(klass)
        self.metrics << klass.new
      end
    end
  end
end
