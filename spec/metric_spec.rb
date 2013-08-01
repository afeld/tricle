require 'spec_helper'

describe Tricle::Metric do
  describe "#yesterday" do
    it "should start and end at midnight" do
      # Aug 1st, 1am
      Timecop.freeze(Time.new(2013, 8, 1, 1)) do
        metric = Tricle::Metric.new
        metric.should_receive(:for_range).with(Time.new(2013, 7, 31), Time.new(2013, 8, 1))
        metric.yesterday
      end
    end
  end
end
