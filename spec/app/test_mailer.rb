require_relative '../../lib/tricle/mailer'
require_relative 'test_metric'

class TestMailer < Tricle::Mailer
  default(
    to: ['recipient1@test.com', 'recipient2@test.com'],
    from: 'sender@test.com'
  )

  metric TestMetric

end
