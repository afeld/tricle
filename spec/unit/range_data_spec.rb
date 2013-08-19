require 'spec_helper'
require_relative '../../lib/tricle/range_data'

describe Tricle::RangeData do
  let(:rd) { Tricle::RangeData.new }
  before do
    rd.add(10.days.ago, 5)
    rd.add(5.days.ago, 6)
    rd.add(1.day.ago, 7)
  end

  describe '#count_for_range' do
    it "should return the count for the days provided" do
      rd.count_for_range(11.days.ago, 3.days.ago).should eq(2)
    end
  end

  describe '#items_for_range' do
    it "should return the items for the days provided" do
      items = rd.items_for_range(11.days.ago, 3.days.ago)
      items.sort.should eq([5, 6])
    end
  end

  describe '#total' do
    it "should count all the items" do
      rd.total.should eq(3)
    end
  end
end
