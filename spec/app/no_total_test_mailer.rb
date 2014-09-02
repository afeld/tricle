require_relative '../../lib/tricle/mailer'
require_relative 'test_metric_with_no_total'

class NoTotalTestMailer < Tricle::Mailer
  default(
    to: ['recipient1@test.com', 'recipient2@test.com'],
    from: 'sender@test.com'
  )

  metric TestMetricWithNoTotal
end
