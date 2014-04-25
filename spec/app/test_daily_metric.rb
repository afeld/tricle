require 'csv'
require_relative '../../lib/tricle/metric'
require_relative '../../lib/tricle/range_data'

class TestDailyMetric < Tricle::Metric
  attr_accessor :data_by_start_on

  def initialize
    super
    self.load_data
  end

  def load_data
    filename = File.join(File.dirname(__FILE__), '..', 'fixtures', 'days.csv')
    data = CSV.read(filename)

    self.data_by_start_on = Tricle::RangeData.new

    data.each do |row|
      start_on = Date.parse(row[0])
      val = row[1].to_i
      self.data_by_start_on.add(start_on, val)
    end
  end

  def size_for_range(start_at, end_at)
    self.items_for_range(start_at, end_at).reduce(&:+)
  end

  def items_for_range(start_at, end_at)
    start_on = start_at.to_date
    end_on = end_at.to_date
    self.data_by_start_on.items_for_range(start_on, end_on)
  end

  def total
    self.data_by_start_on.all_items.reduce(&:+)
  end
end
