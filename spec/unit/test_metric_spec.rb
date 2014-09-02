require 'spec_helper'
require_relative '../app/test_metric'

# test the tests
describe TestMetric do
  let(:metric) { TestMetric.new }

  describe '#weeks_ago' do
    it "should start and end on Monday" do
      expect(metric.weeks_ago(3)).to eq(51)
    end
  end

  describe '#last_week' do
    it "should start and end on Monday" do
      expect(metric.last_week).to eq(62)
    end
  end
end
