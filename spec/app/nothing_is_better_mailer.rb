require_relative '../../lib/tricle/mailer'
require_relative 'test_metric_with_nothing_is_better'

class NothingIsBetterMailer < Tricle::Mailer
  default(to: 'recipient1@test.com', from: 'sender@test.com')

  group "Lower is better" do
    metric TestMetricWithNothingIsBetter
  end
end
