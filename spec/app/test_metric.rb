require 'csv'

class TestMetric < Tricle::Metric
  attr_accessor :data_by_start_at, :total

  def initialize
    super
    self.load_data
  end

  def load_data
    filename = File.join(File.dirname(__FILE__), '..', 'fixtures', 'weeks.csv')
    data = CSV.read(filename)

    self.data_by_start_at = {}
    self.total = 0

    data.each do |row|
      start_at = Time.parse(row[0])
      val = row[2].to_i
      self.total += val
      self.data_by_start_at[start_at] = val
    end
  end

  def for_range(start_at, end_at)
    self.data_by_start_at[start_at]
  end
end
