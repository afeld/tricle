require 'spec_helper'
require_relative '../../lib/tricle/aggregation'

describe Tricle::Aggregation do
  let(:metric) { TestMetric.new }

  describe '#days_ago' do
    it "should start and end at midnight" do
      expect(metric).to receive(:size_for_range).with(Time.new(2013, 7, 29), Time.new(2013, 7, 30))
      metric.days_ago(3)
    end
  end

  describe '#yesterday' do
    it "should start and end at midnight" do
      expect(metric).to receive(:size_for_range).with(Time.new(2013, 7, 31), Time.new(2013, 8, 1))
      metric.yesterday
    end
  end

  describe '#weeks_ago' do
    it "should start and end on Monday" do
      expect(metric).to receive(:size_for_range).with(Time.new(2013, 7, 8), Time.new(2013, 7, 15))
      metric.weeks_ago(3)
    end
  end

  describe '#last_week' do
    it "should start and end on Monday" do
      expect(metric).to receive(:size_for_range).with(Time.new(2013, 7, 22), Time.new(2013, 7, 29))
      metric.last_week
    end
  end

  describe '#weekly_values' do
    it "should return the values by week ascending" do
      expect(metric).to receive(:weeks_ago) {|n| n }.exactly(5).times
      expect(metric.weekly_values(5)).to eq([5,4,3,2,1])
    end
  end

  describe '#week_average_this_quarter' do
    it "should average the values provided by #size_for_range" do
      expect(metric).to receive(:size_for_range).exactly(13).times.and_return(1)
      expect(metric.week_average_this_quarter).to eq(1)
    end
  end
end
