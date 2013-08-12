require 'spec_helper'

describe Tricle::Report do
  let(:report) { Tricle::Report.new }

  describe '#add_metric' do
    it "should add a new group if none are present" do
      report.groups.should eq([])
      report.add_metric(TestMetric)
      report.groups.size.should eq(1)

      metrics = report.groups.first.metric_instances
      metrics.size.should eq(1)
      metrics.first.should be_a(TestMetric)
    end
  end
end
