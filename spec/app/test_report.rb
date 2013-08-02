class TestReport < Tricle::Report
  def metrics
    [TestMetric]
  end
end
