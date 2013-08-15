require 'spec_helper'

require_relative '../../../lib/tricle/presenters/report/base'

describe Tricle::Presenters::Report::Base do
  let(:report) { Tricle::Presenters::Report::Base.new }

  describe '#add_metric' do
    it "should add a new group if none are present" do
      report.sections.should eq([])
      report.add_metric(TestMetric)
      report.sections.size.should eq(1)

      presenters = report.sections.first.metric_presenters
      presenters.size.should eq(1)
      presenters.first.metric.should be_a(TestMetric)
    end
  end

  describe "#number_with_delimiter" do
    it "should put commas between every three digits" do
      report.number_with_delimiter(1234567.89).should eq('1,234,567.89')
    end
  end

  describe "#percent_change" do
    it "should prefix positive values with a +" do
      report.percent_change(110, 100).should eq('+10.0%')
    end

    it "should prefix negative values with a -" do
      report.percent_change(90, 100).should eq('-10.0%')
    end

    it "should handle a zero as the old value with positive change" do
      report.percent_change(10, 0).should eq('+')
    end

    it "should handle a zero as the old value with negative change" do
      report.percent_change(-20, 0).should eq('-')
    end
  end
end
