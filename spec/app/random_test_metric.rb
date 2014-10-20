require_relative '../../lib/tricle/metric'

class RandomTestMetric < Tricle::Metric
  def size_for_range(start_at, end_at)
    @sizes ||= {}
    @sizes["#{start_at}#{end_at}"] ||= rand(0..10)
  end
end
