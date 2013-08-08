require 'spec_helper'

# test the tests
describe TestMetric do
  let(:metric) { TestMetric.new }

  describe "#weeks_ago" do
    it "should start and end on Monday" do
      metric.weeks_ago(3).should eq(51)
    end
  end

  describe "#last_week" do
    it "should start and end on Monday" do
      metric.last_week.should eq(62)
    end
  end
end
