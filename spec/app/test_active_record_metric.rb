require_relative '../../lib/tricle/active_record_metric'

class TestActiveRecordMetric < Tricle::ActiveRecordMetric
  def initialize(opts = {})
    @klass = opts.delete(:klass)
    super(opts)
  end

  def items
    @klass.where(foo: 'bar')
  end
end
