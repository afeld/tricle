require_relative '../../lib/tricle/mailer'
require_relative 'random_test_metric'

class DailyTestMailer < Tricle::Mailer
  default(
    to: ['recipient1@test.com', 'recipient2@test.com'],
    from: 'sender@test.com'
  )

  self.frequency = :daily

  metric RandomTestMetric
end
