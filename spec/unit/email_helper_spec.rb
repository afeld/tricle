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
      helper.number_with_delimiter(-0.123456789).should eq('-0.123456789')
      helper.number_with_delimiter(-1234.56789).should eq('-1,234.56789')
    end
  end

  describe "#sig_figs" do
    it "works for large numbers, positive and negative" do
      helper.sig_figs(1234.56789).should eq(1230)
      helper.sig_figs(-1234.56789).should eq(-1230)
      helper.sig_figs(1234.56789).to_s.should eq('1230')
      helper.sig_figs(-1234.56789).to_s.should eq('-1230')
    end

    it "works for small numbers, positive and negative" do
      helper.sig_figs(0.123456789).should eq(0.123)
      helper.sig_figs(-0.123456789).should eq(-0.123)
      helper.sig_figs(0.123456789).to_s.should eq('0.123')
      helper.sig_figs(-0.123456789).to_s.should eq('-0.123')
    end

    it "works for numbers with leading zeroes, positive and negative" do
      helper.sig_figs(0.00000123456789).should eq(0.00000123)
      helper.sig_figs(-0.00000123456789).should eq(-0.00000123)
      helper.sig_figs(0.00000123456789).to_s.should eq('1.23e-06')
      helper.sig_figs(-0.00000123456789).to_s.should eq('-1.23e-06')
    end

    it "works for integer-like numbers, positive and negative" do
      helper.sig_figs(10).is_a?(Float).should be_true
      helper.sig_figs(10).to_s.should eq('10.0')
      helper.sig_figs(-10).is_a?(Float).should be_true
      helper.sig_figs(-10).to_s.should eq('-10.0')
    end
  end

  describe "#format_number" do
    it "does not decrease the precision of large integers" do
      helper.format_number(123456789).should eq('123,456,789')
      helper.format_number(-123456789).should eq('-123,456,789')
    end

    it "decreases the precision of large numbers to no fewer than 3 sig figs" do
      helper.format_number(123.45).should eq('123')
      helper.format_number(-123.45).should eq('-123')
    end

    it "decreases the precision of small numbers to no fewer than 3 sig figs" do
      helper.format_number(0.00123456789).should eq('0.00123')
      helper.format_number(-0.00123456789).should eq('-0.00123')
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

    it "should not display small values as 0" do
      helper.percent_change(100_001_234, 100_000_000).should eq('+0.00123%')
      helper.percent_change(100_000_000, 100_001_234).should eq('-0.00123%')
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
