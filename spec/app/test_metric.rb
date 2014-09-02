require_relative 'test_metric_with_no_total'

class TestMetric < TestMetricWithNoTotal
  def total
    self.data_by_start_on.all_items.reduce(&:+)
  end
end
