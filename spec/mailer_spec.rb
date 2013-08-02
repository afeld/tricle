require 'spec_helper'

describe Tricle::Mailer do

  class TestMetric < Tricle::Metric
    def for_range(start_at, end_at)
      1234
    end
  end

  class TestReport < Tricle::Report
    def metrics
      [TestMetric]
    end
  end

  class TestInsights < Tricle::Mailer
    default(
      to: ['recipient1@test.com', 'recipient2@test.com'],
      from: 'sender@test.com'
    )

    def report
      TestReport
    end
  end


  describe '#email' do
    def deliver
      TestInsights.email.deliver
      ActionMailer::Base.deliveries.length.should eq(1)
    end

    let(:message) { ActionMailer::Base.deliveries.last }

    it "should respect all the options in the 'default hash'" do
      deliver
      message.to.should eq(['recipient1@test.com', 'recipient2@test.com'])
      message.from.should eq(['sender@test.com'])
    end

    it "should set the subject based on the class name" do
      deliver
      message.subject.should eq("Your Test Insights")
    end

    it "should include the values from the Report" do
      deliver
      message.parts.each do |part|
        source = part.body.raw_source
        source.should include('Test Metric')
        source.should include('1234')
      end
    end
  end
end
