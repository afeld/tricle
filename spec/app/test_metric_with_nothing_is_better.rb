require_relative 'test_metric'

class TestMetricWithNothingIsBetter < TestMetric
  def better
    :nothing
  end
end
