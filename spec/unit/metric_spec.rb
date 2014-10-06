require 'spec_helper'

require_relative '../../lib/tricle/metric'

describe Tricle::Metric do
  let(:metric) { Tricle::Metric.new }

  describe '#size_for_range' do
    it "should raise an exception if #items_for_range isn't overridden" do
      expect { metric.size_for_range(Time.now.yesterday, Time.now) }.to raise_error
    end

    it "should use the number of items by default" do
      allow(metric).to receive(:items_for_range) { [1,2,3] }
      expect(metric.size_for_range(Time.now.yesterday, Time.now)).to eq(3)
    end
  end

  describe '#sparkline?' do
    it 'defaults to Tricle.configuration' do
      expect(Tricle).to receive_message_chain(:configuration, :sparklines).
        and_return(false)

      expect(metric.sparkline?).to eq false
    end

    context 'with options override' do
      let(:sparkline_metric) { Tricle::Metric.new(sparkline: true) }

      it 'ignores Tricle.configuration' do
        expect(sparkline_metric.sparkline?).to eq true
      end
    end
  end
end
