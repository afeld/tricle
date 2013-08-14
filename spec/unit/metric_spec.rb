require 'spec_helper'
require_relative '../../lib/tricle/metric'

describe Tricle::Metric do
  before do
    # Thurs, Aug 1st, 1am
    Timecop.freeze(Time.new(2013, 8, 1, 1))
  end

  let(:metric) { Tricle::Metric.new }

  describe '#total' do
    it "should raise an exception if #items isn't overridden" do
      expect { metric.total }.to raise_error
    end

    it "should use the number of items by default" do
      metric.stub(:items) { [1,2,3] }
      metric.total.should eq(3)
    end
  end

  describe '#days_ago' do
    it "should start and end at midnight" do
      metric.should_receive(:for_range).with(Time.new(2013, 7, 29), Time.new(2013, 7, 30))
      metric.days_ago(3)
    end
  end

  describe '#yesterday' do
    it "should start and end at midnight" do
      metric.should_receive(:for_range).with(Time.new(2013, 7, 31), Time.new(2013, 8, 1))
      metric.yesterday
    end
  end

  describe '#weeks_ago' do
    it "should start and end on Monday" do
      metric.should_receive(:for_range).with(Time.new(2013, 7, 8), Time.new(2013, 7, 15))
      metric.weeks_ago(3)
    end
  end

  describe '#last_week' do
    it "should start and end on Monday" do
      metric.should_receive(:for_range).with(Time.new(2013, 7, 22), Time.new(2013, 7, 29))
      metric.last_week
    end
  end

  describe '#week_average_this_quarter' do
    it "should average the values provided by #for_range" do
      metric.should_receive(:for_range).exactly(13).times.and_return(1)
      metric.week_average_this_quarter.should eq(1)
    end
  end
end
