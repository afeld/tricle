require 'spec_helper'

require_relative '../../lib/tricle/presenters/helper'

describe Tricle::Presenters::Helper do
  describe '.number_with_delimiter' do
    it "should put commas between every three digits" do
      Tricle::Presenters::Helper.number_with_delimiter(1234567.89).should eq('1,234,567.89')
    end
  end

  describe '.percent_change' do
    it "should prefix positive values with a +" do
      Tricle::Presenters::Helper.percent_change(110, 100).should eq('+10.0%')
    end

    it "should prefix negative values with a -" do
      Tricle::Presenters::Helper.percent_change(90, 100).should eq('-10.0%')
    end

    it "should handle a zero as the old value with positive change" do
      Tricle::Presenters::Helper.percent_change(10, 0).should eq('+')
    end

    it "should handle a zero as the old value with negative change" do
      Tricle::Presenters::Helper.percent_change(-20, 0).should eq('-')
    end
  end
end
