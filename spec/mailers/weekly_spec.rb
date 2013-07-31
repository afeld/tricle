require 'spec_helper'

describe 'weekly mailer' do
  class TestMailer < ActionMailer::Base
    default from: 'sender@test.com'
    def weekly_mail
      mail(to: 'recipient@test.com', subject: "Your Weekly Stats", body: "foo")
    end
  end

  it "should set the subject" do
    TestMailer.weekly_mail.deliver
    ActionMailer::Base.deliveries.length.should eq(1)
    ActionMailer::Base.deliveries.last.subject.should eq("Your Weekly Stats")
  end

  it "should set the body" do
    TestMailer.weekly_mail.deliver
    ActionMailer::Base.deliveries.length.should eq(1)
    ActionMailer::Base.deliveries.last.body.should eq("foo")
  end
end
