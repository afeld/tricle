require_relative 'section'

module Tricle
  class List < Section
    attr_reader :block, :metric

    def initialize(klass, &block)
      @metric = klass.new
      @block = block
    end

    def title
      self.metric.title
    end

    def items
      self.metric.items
    end

    def items_markup
      markup = ''
      self.items.each do |item|
        val = self.block.call(item)
        markup << %{<tr><td class="list-item" colspan="4">#{val}</td></tr>}
      end

      markup
    end
  end
end
