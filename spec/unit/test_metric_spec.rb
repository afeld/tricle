require 'spec_helper'
require_relative '../app/test_metric'

# test the tests
describe TestMetric do
  let(:metric) { TestMetric.new }

  describe '#weeks_ago' do
    it "should start and end on Monday" do
      presenter.weeks_ago(3).should eq(357)
    end
  end

  describe '#last_week' do
    it "should start and end on Monday" do
      presenter.last_week.should eq(434)
    end
  end
end
