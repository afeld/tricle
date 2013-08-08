require 'spec_helper'

# test the tests
describe TestMetric do
  before do
    # Thurs, Aug 1st, 1am
    Timecop.freeze(Time.new(2013, 8, 1, 1, 0, 0, '-04:00'))
  end

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
