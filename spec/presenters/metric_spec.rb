require 'spec_helper'
require_relative '../../lib/tricle/presenters/metric'

describe Tricle::Presenters::Metric do
  let(:presenter) { Tricle::Presenters::Metric.new(TestMetric, Time.now) }
  let(:metric) { presenter.metric }

  describe '#days_ago' do
    it "should start and end at midnight" do
      metric.should_receive(:size_for_range).with(Time.new(2013, 7, 29), Time.new(2013, 7, 30))
      presenter.days_ago(3)
    end
  end

  describe '#yesterday' do
    it "should start and end at midnight" do
      metric.should_receive(:size_for_range).with(Time.new(2013, 7, 31), Time.new(2013, 8, 1))
      presenter.yesterday
    end
  end

  describe '#weeks_ago' do
    it "should start and end on Monday" do
      metric.should_receive(:size_for_range).with(Time.new(2013, 7, 8), Time.new(2013, 7, 15))
      presenter.weeks_ago(3)
    end
  end

  describe '#last_week' do
    it "should start and end on Monday" do
      metric.should_receive(:size_for_range).with(Time.new(2013, 7, 22), Time.new(2013, 7, 29))
      presenter.last_week
    end
  end

  describe '#week_average_this_quarter' do
    it "should average the values provided by #size_for_range" do
      metric.should_receive(:size_for_range).exactly(13).times.and_return(1)
      presenter.week_average_this_quarter.should eq(1)
    end
  end
end
