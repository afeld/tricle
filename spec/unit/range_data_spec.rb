require 'spec_helper'
require_relative '../../lib/tricle/range_data'

describe Tricle::RangeData do
  let(:rd) { Tricle::RangeData.new }
  before do
    rd.add(10.days.ago, 5)
    rd.add(5.days.ago, 6)
    rd.add(1.day.ago, 7)
  end

  describe '#all_items' do
    it "should return all the items" do
      expect(rd.all_items.sort).to eq([5, 6, 7])
    end
  end

  describe '#items_for_range' do
    it "should return the items for the days provided" do
      items = rd.items_for_range(11.days.ago, 3.days.ago)
      expect(items.sort).to eq([5, 6])
    end
  end
end
