require 'spec_helper'

describe Tricle::Mailer do
  class TestInsights < Tricle::Mailer
    default(
      to: ['recipient1@test.com', 'recipient2@test.com'],
      from: 'sender@test.com'
    )
  end

  describe '#deliver' do
    it "should set the subject based on the class name" do
      TestInsights.deliver
      ActionMailer::Base.deliveries.length.should eq(1)
      ActionMailer::Base.deliveries.last.subject.should eq("Your Test Insights")
    end
  end
end
