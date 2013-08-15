require 'spec_helper'
require_relative '../../lib/tricle/presenters/group'
require_relative '../app/test_metric'

describe Tricle::Presenters::Group do
  let(:group) { Tricle::Presenters::Group.new(Time.now) }

  describe '#add_metric' do
    it "should add a new metric instance" do
      group.add_metric(TestMetric)
      group.metric_presenters.size.should eq(1)
      presenter = group.metric_presenters.first
      presenter.should be_a(Tricle::Presenters::Metric)
      presenter.metric.should be_a(TestMetric)
    end
  end
end
