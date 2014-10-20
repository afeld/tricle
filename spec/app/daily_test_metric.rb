require_relative 'test_metric_with_no_total'

class DailyTestMetric < TestMetricWithNoTotal
  def fixture_filename
    'days.csv'
  end
end
