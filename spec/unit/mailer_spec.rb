require 'spec_helper'
require_relative '../../lib/tricle/mailer'
require_relative '../app/group_test_mailer'
require_relative '../app/list_test_mailer'
require_relative '../app/test_mailer'

describe Tricle::Mailer do
  def deliver(klass)
    klass.email.deliver
    ActionMailer::Base.deliveries.length.should eq(1)
  end

  let(:message) { ActionMailer::Base.deliveries.last }
  let(:markup) { message.html_part.body.to_s }

  describe '.email' do
    before do
      deliver(TestMailer)
    end

    it "should respect all the options in the 'default hash'" do
      message.to.should eq(['recipient1@test.com', 'recipient2@test.com'])
      message.from.should eq(['sender@test.com'])
    end

    it "should set the subject based on the class name" do
      message.subject.should eq("Your Test Mailer")
    end

    it "should include the Metric values in the HTML part" do
      markup.should include('Test Metric')
      markup.should match(/\b62\b/) # last week
      markup.should match(/\b787\b/) # total
    end

    it "should link to the Issues page in the text part" do
      source = message.text_part.body.to_s
      source.should include('github.com/artsy/tricle')
    end
  end

  describe '.group' do
    it "should include the group title" do
      deliver(GroupTestMailer)
      markup.should include("Test Group 1")
      markup.should include("Test Group 2")
      markup.should include("Test Metric")
    end
  end

  describe '.list' do
    it "should include the list title" do
      deliver(ListTestMailer)
      markup.should include("Test Metric")
      markup.should include('83.0')
      markup.should include('82.0')
    end
  end

  describe '.send_all' do
    it "should .deliver all defined mailers" do
      Tricle::Mailer.send_all
      ActionMailer::Base.deliveries.length.should eq(3)
    end
  end
end
