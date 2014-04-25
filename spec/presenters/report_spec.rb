require 'spec_helper'

require_relative '../../lib/tricle/presenters/report'

describe Tricle::Presenters::Report do
  let(:report) { Tricle::Presenters::Report.new }

  describe '#add_metric' do
    it "adds a new group if none are present" do
      report.sections.should eq([])
      report.add_metric(TestMetric)
      report.sections.size.should eq(1)

      presenters = report.sections.first.metric_presenters
      presenters.size.should eq(1)
      presenters.first.metric.should be_a(TestMetric)
    end
  end
  describe '#add_group' do
    it 'adds a new group and allows specifying a daily option' do
      report.sections.should eq([])
      report.add_group('Daily Test', daily: true)
      report.sections.size.should eq(1)
      report.sections.first.title.should eq('Daily Test')
      report.sections.first.should be_daily
    end
    it 'adds a new group without a daily option' do
      report.sections.should eq([])
      report.add_group('Daily Test')
      report.sections.size.should eq(1)
      report.sections.first.title.should eq('Daily Test')
      report.sections.first.should_not be_daily
    end
  end
end
