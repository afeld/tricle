require 'spec_helper'

describe Tricle::Metric do
  before do
    # Thurs, Aug 1st, 1am
    Timecop.freeze(Time.new(2013, 8, 1, 1))
  end

  describe "#yesterday" do
    it "should start and end at midnight" do
      metric = Tricle::Metric.new
      metric.should_receive(:for_range).with(Time.new(2013, 7, 31), Time.new(2013, 8, 1))
      metric.yesterday
    end
  end

  describe "#last_week" do
    it "should start and end on Monday" do
      metric = Tricle::Metric.new
      metric.should_receive(:for_range).with(Time.new(2013, 7, 22), Time.new(2013, 7, 29))
      metric.last_week
    end
  end
end
