require 'spec_helper'
require_relative '../app/test_active_record_metric'

describe TestActiveRecordMetric do
  let(:klass) { class_double('User') }
  let(:metric) { TestActiveRecordMetric.new(klass: klass) }
  let!(:start_time) { Time.now }
  let!(:end_time) { start_time - 1.day }

  describe '#total' do
    it 'executes a #count query' do
      expect(klass).to receive_message_chain(:where, :count).and_return(1)
      expect(metric.total).to eq 1
    end
  end

  describe '#size_for_range' do
    it 'executes a #count query with the correct filters' do
      # These stubs are ugly, but we want to test the arguments received
      # to the method called in the middle of the message chain...
      expect(klass).to receive(:where).and_return(klass)
      expect(klass).to receive(:where).
                        with('created_at' => start_time..end_time).
                        and_return(klass)
      expect(klass).to receive(:count).and_return(1)
      expect(metric.size_for_range(start_time, end_time)).to eq 1
    end
  end

  describe '#items_for_range' do
    it 'executes a query with the correct filters' do
      expect(klass).to receive(:where).and_return(klass)
      expect(klass).to receive(:where).
                        with('created_at' => start_time..end_time).
                        and_return(['foobar'])
      expect(metric.items_for_range(start_time, end_time)).to eq ['foobar']
    end
  end

  describe 'overriding the time_column' do
    before do
      allow(metric).to receive(:time_column).and_return('updated_at')
    end

    it 'executes a query with the correct filters' do
      expect(klass).to receive(:where).and_return(klass)
      expect(klass).to receive(:where).
                        with('updated_at' => start_time..end_time).
                        and_return(['fuzz'])
      expect(metric.items_for_range(start_time, end_time)).to eq ['fuzz']
    end
  end
end
