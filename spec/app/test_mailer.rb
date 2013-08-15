require_relative '../../lib/tricle/mailer/weekly'
require_relative 'test_metric'

class TestMailer < Tricle::Mailer::Weekly
  default(
    to: ['recipient1@test.com', 'recipient2@test.com'],
    from: 'sender@test.com'
  )

  metric TestMetric
end
