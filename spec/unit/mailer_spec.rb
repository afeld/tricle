require 'spec_helper'
require_relative '../../lib/tricle/mailer'
require_relative '../app/group_test_mailer'
require_relative '../app/list_test_mailer'
require_relative '../app/test_mailer'
require_relative '../app/lower_is_better_mailer'
require_relative '../app/higher_is_better_mailer'
require_relative '../app/nothing_is_better_mailer'

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
      expect(markup).to match(/\b74\b/) # last week
      expect(markup).to match(/\b806\b/) # total
    end

    it "should link to the Issues page in the text part" do
      source = message.text_part.body.to_s
      expect(source).to include('github.com/artsy/tricle')
    end
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
      expect(markup).to include('74.0')
      expect(markup).not_to include('79.0')
    end
  end

  describe 'cell class' do
    it 'should default to higher is better' do
      deliver(HigherIsBetterMailer)
      markup.should include("positive")
      markup.should_not include("negative")
    end

    it 'can specify lower is better' do
      deliver(LowerIsBetterMailer)
      markup.should include("negative")
      markup.should_not include("positive")
    end

    it 'can specify that nothing is better or worse' do
      deliver(NothingIsBetterMailer)
      markup.should_not include("negative")
      markup.should_not include("positive")
    end
  end

  describe '.send_all' do
    it "should .deliver all defined mailers" do
      Tricle::Mailer.send_all
      expect(ActionMailer::Base.deliveries.length).to eq(6)
    end
  end
end
