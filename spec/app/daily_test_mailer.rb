require_relative '../../lib/tricle/mailer'
require_relative 'test_daily_metric'

class DailyTestMailer < Tricle::Mailer
  default(to: 'recipient1@test.com', from: 'sender@test.com')

  group "Daily Group 1", daily: true do
    metric TestDailyMetric
  end
end
