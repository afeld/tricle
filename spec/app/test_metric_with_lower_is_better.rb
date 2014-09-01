require_relative 'test_metric'

class TestMetricWithLowerIsBetter < TestMetric
  def better
    :lower
  end
end
