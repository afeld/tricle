require_relative '../../lib/tricle/mailer'
require_relative 'monthly_test_metric'

class MonthlyTestMailer < Tricle::Mailer
  default(
    to: ['recipient1@test.com', 'recipient2@test.com'],
    from: 'sender@test.com'
  )

  self.period = :month

  metric MonthlyTestMetric
end
