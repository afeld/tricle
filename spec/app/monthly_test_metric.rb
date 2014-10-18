require_relative 'test_metric_with_no_total'

class MonthlyTestMetric < TestMetricWithNoTotal
  def fixture_filename
    'months.csv'
  end
end
