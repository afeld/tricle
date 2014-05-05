require 'spec_helper'
require_relative '../../lib/tricle/email_helper'

describe Tricle::EmailHelper do
  class HelperTester
    include Tricle::EmailHelper
  end

  let(:helper) { HelperTester.new }

  describe "#number_with_delimiter" do
    it "should put commas between every three digits" do
      helper.number_with_delimiter(1234567.89).should eq('1,234,567.89')
      helper.number_with_delimiter(1234567).should eq('1,234,567')
    end

    it "should not put commas between every three digits of the decimal portion of non-integers" do
      helper.number_with_delimiter(0.123456789).should eq('0.123456789')
      helper.number_with_delimiter(1234.56789).should eq('1,234.56789')
    end
  end

  describe "#percent_change" do
    it "should prefix positive values with a +" do
      helper.percent_change(110, 100).should eq('+10.0%')
    end

    it "should prefix negative values with a -" do
      helper.percent_change(90, 100).should eq('-10.0%')
    end

    it "should handle a zero as the old value with positive change" do
      helper.percent_change(10, 0).should eq('+')
    end

    it "should handle a zero as the old value with negative change" do
      helper.percent_change(-20, 0).should eq('-')
    end
  end

  describe "#single_week_dates_cell" do
    it "should not include the last day of the week" do
      start_at = Time.new(2013, 7, 22) # a Monday
      markup = helper.single_week_dates_cell(start_at)
      markup.should include('7/22/13')
      markup.should include('7/28/13')
    end
  end
end
