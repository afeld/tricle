require_relative '../../lib/tricle/mailer'
require_relative 'test_metric_with_lower_is_better'

class LowerIsBetterMailer < Tricle::Mailer
  default(to: 'recipient1@test.com', from: 'sender@test.com')

  group "Lower is better" do
    metric TestMetricWithLowerIsBetter
  end
end
