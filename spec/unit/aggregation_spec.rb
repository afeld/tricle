require 'spec_helper'
require_relative '../../lib/tricle/aggregation'

describe Tricle::Aggregation do
  let(:metric) { TestMetric.new }

  describe '#periods_ago' do
    context 'day' do
      it "should start and end at midnight" do
        expect(metric).to receive(:size_for_range).with(Time.new(2013, 7, 29), Time.new(2013, 7, 30))
        metric.periods_ago(:day, 3)
      end
    end

    context 'week' do
      it "should start and end on Monday" do
        expect(metric).to receive(:size_for_range).with(Time.new(2013, 7, 8), Time.new(2013, 7, 15))
        metric.periods_ago(:week, 3)
      end
    end
  end

  describe '#range_values' do
    context 'week' do
      it "should return the values by week ascending" do
        expect(metric).to receive(:periods_ago) {|period, n| n }.exactly(5).times
        expect(metric.range_values(:week, 5)).to eq([5,4,3,2,1])
      end
    end
  end

  describe '#range_average' do
    context 'week' do
      it "should average the values provided by #size_for_range" do
        expect(metric).to receive(:size_for_range).exactly(13).times.and_return(1)
        expect(metric.range_average(:week, 13)).to eq(1)
      end
    end
  end
end
