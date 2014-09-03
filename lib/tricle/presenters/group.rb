require_relative 'section'

module Tricle
  module Presenters
    class Group < Section
      attr_reader :metrics, :title

      def initialize(title=nil)
        @title = title
        @metrics = []
      end

      def add_metric(klass, opts = {})
        self.metrics << klass.new(opts)
      end
    end
  end
end
