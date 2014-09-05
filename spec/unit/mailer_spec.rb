require 'spec_helper'
require_relative '../../lib/tricle/mailer'
require_relative '../app/group_test_mailer'
require_relative '../app/list_test_mailer'
require_relative '../app/no_total_test_mailer'
require_relative '../app/test_mailer'

describe Tricle::Mailer do
  def deliver(klass)
    klass.email.deliver
    expect(ActionMailer::Base.deliveries.length).to eq(1)
  end

  let(:message) { ActionMailer::Base.deliveries.last }
  let(:markup) { message.html_part.body.to_s }

  describe '.email' do
    before do
      deliver(TestMailer)
    end

    it "should respect all the options in the 'default hash'" do
      expect(message.to).to eq(['recipient1@test.com', 'recipient2@test.com'])
      expect(message.from).to eq(['sender@test.com'])
    end

    it "should set the subject based on the class name" do
      expect(message.subject).to eq("Your Test Mailer")
    end

    it "should include the Metric values in the HTML part" do
      expect(markup).to include('Test Metric')
      expect(markup).to match(/\b62\b/) # last week
      expect(markup).to match(/\b787\b/) # total
    end

    it "should link to the Issues page in the text part" do
      source = message.text_part.body.to_s
      expect(source).to include('github.com/artsy/tricle')
    end
  end

  it "should exclude the total if not defined" do
    deliver(NoTotalTestMailer)
    expect(markup).to_not include('total')
    expect(markup).to_not match(/\b787\b/)
  end

  describe '.group' do
    it "should include the group title" do
      deliver(GroupTestMailer)
      expect(markup).to include("Test Group 1")
      expect(markup).to include("Test Group 2")
      expect(markup).to include("Test Metric")
    end
  end

  describe '.list' do
    it "should include the list title" do
      deliver(ListTestMailer)
      expect(markup).to include("Test Metric")
      expect(markup).to include('62.0')
      expect(markup).not_to include('79.0')
    end
  end

  describe '.send_all' do
    it "should .deliver all defined mailers" do
      Tricle::Mailer.send_all
      expect(ActionMailer::Base.deliveries.length).to eq(4)
    end
  end

  describe '.send_all_if_beginning_of_week' do
    it "shouldn't do anything if not the beginning of the week" do
      expect(Tricle::Mailer).to_not receive(:send_all)
      Tricle::Mailer.send_all_if_beginning_of_week
    end

    it "should send if it's the beginning of the week" do
      Timecop.freeze(Time.now - 3.days) # Monday
      expect(Tricle::Mailer).to receive(:send_all)
      Tricle::Mailer.send_all_if_beginning_of_week
    end
  end
end
