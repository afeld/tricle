require 'spec_helper'
require_relative '../app/test_metric'
require_relative '../../lib/tricle/presenters/metric'

# test the tests
describe TestMetric do
  let(:presenter) { Tricle::Presenters::Metric.new(TestMetric) }

  describe '#weeks_ago' do
    it "should start and end on Monday" do
      expect(presenter.weeks_ago(3)).to eq(51)
    end
  end

  describe '#last_week' do
    it "should start and end on Monday" do
      expect(presenter.last_week).to eq(62)
    end
  end
end
