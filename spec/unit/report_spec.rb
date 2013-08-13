require 'spec_helper'

require_relative '../../lib/tricle/group'
require_relative '../app/test_metric'

describe Tricle::Report do
  let(:report) { Tricle::Report.new }

  describe '#add_metric' do
    it "should add a new group if none are present" do
      report.sections.should eq([])
      report.add_metric(TestMetric)
      report.sections.size.should eq(1)
      group = report.sections.first
      group.should be_a(Tricle::Group)

      metrics = group.metric_instances
      metrics.size.should eq(1)
      metrics.first.should be_a(TestMetric)
    end
  end
end
