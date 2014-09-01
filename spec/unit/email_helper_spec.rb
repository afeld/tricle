require 'spec_helper'
require_relative '../../lib/tricle/email_helper'

describe Tricle::EmailHelper do
  class HelperTester
    include Tricle::EmailHelper
  end

  let(:helper) { HelperTester.new }

  describe "#number_with_delimiter" do
    it "should put commas between every three digits" do
      expect(helper.number_with_delimiter(1234567.89)).to eq('1,234,567.89')
      expect(helper.number_with_delimiter(1234567)).to eq('1,234,567')
    end

    it "should not put commas between every three digits of the decimal portion of non-integers" do
      expect(helper.number_with_delimiter(0.123456789)).to eq('0.123456789')
      expect(helper.number_with_delimiter(1234.56789)).to eq('1,234.56789')
      expect(helper.number_with_delimiter(-0.123456789)).to eq('-0.123456789')
      expect(helper.number_with_delimiter(-1234.56789)).to eq('-1,234.56789')
    end
  end

  describe "#sig_figs" do
    it "works for large numbers, positive and negative" do
      expect(helper.sig_figs(1234.56789)).to eq(1230)
      expect(helper.sig_figs(-1234.56789)).to eq(-1230)
      expect(helper.sig_figs(1234.56789).to_s).to eq('1230')
      expect(helper.sig_figs(-1234.56789).to_s).to eq('-1230')
    end

    it "works for small numbers, positive and negative" do
      expect(helper.sig_figs(0.123456789)).to eq(0.123)
      expect(helper.sig_figs(-0.123456789)).to eq(-0.123)
      expect(helper.sig_figs(0.123456789).to_s).to eq('0.123')
      expect(helper.sig_figs(-0.123456789).to_s).to eq('-0.123')
    end

    it "works for numbers with leading zeroes, positive and negative" do
      expect(helper.sig_figs(0.00000123456789)).to eq(0.00000123)
      expect(helper.sig_figs(-0.00000123456789)).to eq(-0.00000123)
      expect(helper.sig_figs(0.00000123456789).to_s).to eq('1.23e-06')
      expect(helper.sig_figs(-0.00000123456789).to_s).to eq('-1.23e-06')
    end

    it "works for integer-like numbers, positive and negative" do
      expect(helper.sig_figs(10).is_a?(Float)).to be_truthy
      expect(helper.sig_figs(10).to_s).to eq('10.0')
      expect(helper.sig_figs(-10).is_a?(Float)).to be_truthy
      expect(helper.sig_figs(-10).to_s).to eq('-10.0')
    end
  end

  describe "#format_number" do
    it "does not decrease the precision of large integers" do
      expect(helper.format_number(123456789)).to eq('123,456,789')
      expect(helper.format_number(-123456789)).to eq('-123,456,789')
    end

    it "decreases the precision of large numbers to no fewer than 3 sig figs" do
      expect(helper.format_number(123.45)).to eq('123')
      expect(helper.format_number(-123.45)).to eq('-123')
    end

    it "decreases the precision of small numbers to no fewer than 3 sig figs" do
      expect(helper.format_number(0.00123456789)).to eq('0.00123')
      expect(helper.format_number(-0.00123456789)).to eq('-0.00123')
    end
  end

  describe "#percent_change" do
    it "should prefix positive values with a +" do
      expect(helper.percent_change(110, 100)).to eq('+10.0%')
    end

    it "should prefix negative values with a -" do
      expect(helper.percent_change(90, 100)).to eq('-10.0%')
    end

    it "should handle a zero as the old value with positive change" do
      expect(helper.percent_change(10, 0)).to eq('+')
    end

    it "should handle a zero as the old value with negative change" do
      expect(helper.percent_change(-20, 0)).to eq('-')
    end

    it "should not display small values as 0" do
      expect(helper.percent_change(100_001_234, 100_000_000)).to eq('+0.00123%')
      expect(helper.percent_change(100_000_000, 100_001_234)).to eq('-0.00123%')
    end
  end

  describe '#percent_change_cell' do
    it "should be positive with positive change and better = :higher" do
      expect(helper.percent_change_cell(4, 2, :higher)).to match('positive')
    end

    it "should be negative with positive change and better = :lower" do
      expect(helper.percent_change_cell(4, 2, :lower)).to match('negative')
    end

    it "should not be positive or negative with positive change and better = :none" do
      expect(helper.percent_change_cell(4, 2, :none)).to_not match('positive')
      expect(helper.percent_change_cell(4, 2, :none)).to_not match('negative')
    end
  end

  describe "#single_week_dates_cell" do
    it "should not include the last day of the week" do
      start_at = Time.new(2013, 7, 22) # a Monday
      markup = helper.single_week_dates_cell(start_at)
      expect(markup).to include('7/22/13')
      expect(markup).to include('7/28/13')
    end
  end
end
