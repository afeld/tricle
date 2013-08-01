require 'csv'

class TestMetric < Tricle::Metric
  def initialize
    super
    filename = File.join(File.dirname(__FILE__), '..', 'fixtures', 'weeks.csv')
    @data = CSV.read(filename)
    @data_by_start_at = {}
    @data.each do |row|
      start_at = Time.parse(row[0])
      @data_by_start_at[start_at] = row[2]
    end
  end

  def for_range(start_at, end_at)
    @data_by_start_at[start_at]
  end
end
