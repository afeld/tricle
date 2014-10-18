require 'spec_helper'
require_relative '../../lib/tricle/mailer'
require_relative '../app/group_test_mailer'
require_relative '../app/list_test_mailer'
require_relative '../app/list_test_mailer_with_options'
require_relative '../app/no_total_test_mailer'
require_relative '../app/test_mailer'
require_relative '../app/daily_test_mailer'
require_relative '../app/monthly_test_mailer'

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

  describe 'daily email' do
    before do
      deliver(DailyTestMailer)
    end

    it 'includes the correct cell headers' do
      expect(markup).to include('2 days ago')
      expect(markup).to include('Yesterday')
    end

    it 'includes the correct data' do
      expect(markup).to include('14.1')
      expect(markup).to include('20.0')
      expect(markup).to include('11.0')
    end

    it 'includes the correct averages' do
      expect(markup).to include('-22.2')
      expect(markup).to include('-45.0')
    end
  end

  describe 'monthly email' do
    before do
      deliver(MonthlyTestMailer)
    end

    it 'includes the correct cell headers' do
      expect(markup).to include('Previous month')
      expect(markup).to include('Last month')
    end

    it 'includes the correct data' do
      expect(markup).to include('241')
      expect(markup).to include('200')
      expect(markup).to include('429')
    end

    it 'includes the correct averages' do
      expect(markup).to include('77.8')
      expect(markup).to include('114.0')
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
      expect {
        Tricle::Mailer.send_all_now
      }.to change { ActionMailer::Base.deliveries.length }.by(7)
    end
  end

  describe '.send_all' do
    it 'sends daily emails' do
      allow_any_instance_of(Tricle::Time).to receive(:beginning_of_week?).
        and_return(false)

      allow_any_instance_of(Tricle::Time).to receive(:beginning_of_month?).
        and_return(false)

      expect {
        Tricle::Mailer.send_all
      }.to change { ActionMailer::Base.deliveries.length }.by(1)
    end

    it 'sends weekly emails' do
      allow_any_instance_of(Tricle::Time).to receive(:beginning_of_week?).
        and_return(true)

      allow_any_instance_of(Tricle::Time).to receive(:beginning_of_month?).
        and_return(false)

      expect {
        Tricle::Mailer.send_all
      }.to change { ActionMailer::Base.deliveries.length }.by(6)
    end

    it 'sends monthly emails' do
      allow_any_instance_of(Tricle::Time).to receive(:beginning_of_week?).
        and_return(true)

      allow_any_instance_of(Tricle::Time).to receive(:beginning_of_month?).
        and_return(true)

      expect {
        Tricle::Mailer.send_all
      }.to change { ActionMailer::Base.deliveries.length }.by(7)
    end
  end
end
