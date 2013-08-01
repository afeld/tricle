require 'spec_helper'

describe Tricle::Mailer do
  class TestInsights < Tricle::Mailer
    default from: 'sender@test.com'

    def recipients
      ['recipient1@test.com', 'recipient2@test.com']
    end
  end

  describe '#deliver' do
    it "should set the subject based on the class name" do
      TestInsights.deliver
      ActionMailer::Base.deliveries.length.should eq(1)
      ActionMailer::Base.deliveries.last.subject.should eq("Your Test Insights")
    end

    it "should send to all the recipients" do
      TestInsights.deliver
      ActionMailer::Base.deliveries.last.to.should eq(['recipient1@test.com', 'recipient2@test.com'])
    end
  end
end
