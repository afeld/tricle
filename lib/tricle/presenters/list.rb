require_relative 'section'

module Tricle
  class List < Section
    attr_reader :block, :metric

    def initialize(now, klass, &block)
      @metric = klass.new
      @block = block
      super(now)
    end

    def title
      self.metric.title
    end

    def items_markup(start_at, end_at)
      markup = ''
      items = self.metric.items_for_range(start_at, end_at)
      items.each do |item|
        val = self.block.call(item)
        markup << %{<tr><td class="list-item" colspan="4">#{val}</td></tr>}
      end

      markup
    end

    def list_markup
      start_at = self.weeks_ago(1).to_time
      end_at = start_at + 7.days
      self.items_markup(start_at, end_at).html_safe
    end
  end
end
