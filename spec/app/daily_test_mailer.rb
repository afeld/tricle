require_relative '../../lib/tricle/mailer'
require_relative 'test_daily_metric'
require_relative 'test_metric'

class DailyTestMailer < Tricle::Mailer
  default(to: 'recipient1@test.com', from: 'sender@test.com')

  group "Daily Group 1", frequency: :daily do
    metric TestDailyMetric
  end

  group 'Weekly Group 1' do
    metric TestMetric
  end
end
