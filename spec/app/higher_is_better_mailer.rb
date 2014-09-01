require_relative '../../lib/tricle/mailer'
require_relative 'test_metric_with_lower_is_better'

class HigherIsBetterMailer < Tricle::Mailer
  default(to: 'recipient1@test.com', from: 'sender@test.com')

  group "Higher is better" do
    metric TestMetric
  end
end
