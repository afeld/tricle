# TODO add this class to the README?
module Tricle
  class RangeData
    def initialize
      @data = {}
    end

    def add(key, val)
      @data[key] ||= []
      @data[key] << val
    end

    def all_items
      @data.values.flatten
    end

    def items_for_range(low, high, inclusive=false)
      @data.reduce([]) { |memo, (key, values)|
        if key >= low && key < high
          memo + values
        else
          memo
        end
      }
    end
  end
end
