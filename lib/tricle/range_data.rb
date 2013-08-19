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
      @data.reduce(0) { |sum, (key, values)|
        if key >= low && key < high
          sum + values.length
        else
          sum
        end
      }
    end
  end
end
