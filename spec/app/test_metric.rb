require 'csv'
require_relative '../../lib/tricle/metric'

class TestMetric < Tricle::Metric
  attr_accessor :data_by_start_on, :total

  def initialize
    super
    self.load_data
  end

  def load_data
    filename = File.join(File.dirname(__FILE__), '..', 'fixtures', 'weeks.csv')
    data = CSV.read(filename)

    self.data_by_start_on = {}
    self.total = 0

    data.each do |row|
      start_on = Date.parse(row[0])
      val = row[2].to_i
      self.total += val
      self.data_by_start_on[start_on] = val
    end
  end

  def for_range(start_at, end_at)
    start_on = start_at.to_date
    self.data_by_start_on[start_on]
  end
end
