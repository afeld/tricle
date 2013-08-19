module Tricle
  class RangeData
    def initialize
      @data = {}
    end

    def add(key, val)
      @data[key] ||= []
      @data[key] << val
    end

    def count_for_range(low, high)
      self.items_for_range(low, high).size
    end

    def items_for_range(low, high)
      @data.reduce([]) { |memo, (key, values)|
        if key >= low && key < high
          memo + values
        else
          memo
        end
      }
    end

    def total
      @data.values.flatten.size
    end
  end
end
