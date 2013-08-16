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
end
