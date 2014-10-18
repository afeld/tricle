require 'spec_helper'
require_relative '../../lib/tricle/mailer'
require_relative '../app/group_test_mailer'
require_relative '../app/list_test_mailer'
require_relative '../app/list_test_mailer_with_options'
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

    it "includes sparklines by default" do
      expect(markup).to include('sparklines.herokuapp.com')
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

    it "should pass options" do
      deliver(ListTestMailerWithOptions)
      expect(markup).to include("TheNewTitle")
    end
  end

  describe '.send_all_now' do
    it "should .deliver all defined mailers" do
      Tricle::Mailer.send_all_now
      expect(ActionMailer::Base.deliveries.length).to eq(5)
    end
  end

  describe '.send_all' do
    context 'frequency = weekly' do
      it "shouldn't do anything if not the beginning of the week" do
        allow_any_instance_of(Tricle::Time).to receive(:beginning_of_week?).
          and_return(false)

        expect(Tricle::Mailer).to receive(:send_mailers).with([])
        Tricle::Mailer.send_all
      end

      it "should send if it's the beginning of the week" do
        allow_any_instance_of(Tricle::Time).to receive(:beginning_of_week?).
          and_return(true)

        expect(Tricle::Mailer).to receive(:send_mailers).with(
          Tricle::Mailer.descendants
        )

        Tricle::Mailer.send_all
      end
    end

    context 'frequency = monthly' do
      before do
        allow(Tricle::Mailer).to receive(:frequency).and_return(:monthly)
      end

      it "shouldn't do anything if not the beginning of the month" do
        allow_any_instance_of(Tricle::Time).to receive(:beginning_of_month?).
          and_return(false)

        expect(Tricle::Mailer).to receive(:send_mailers).with([])
        Tricle::Mailer.send_all
      end

      it "should send if it's the beginning of the month" do
        allow_any_instance_of(Tricle::Time).to receive(:beginning_of_month?).
          and_return(true)

        expect(Tricle::Mailer).to receive(:send_mailers).with(
          Tricle::Mailer.descendants
        )

        Tricle::Mailer.send_all
      end
    end
  end
end
