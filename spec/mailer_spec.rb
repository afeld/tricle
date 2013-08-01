require 'spec_helper'

describe Tricle::Mailer do
  class TestInsights < Tricle::Mailer
    default(
      to: ['recipient1@test.com', 'recipient2@test.com'],
      from: 'sender@test.com'
    )
  end

  describe '#deliver' do
    def deliver
      TestInsights.deliver
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
  end
end
