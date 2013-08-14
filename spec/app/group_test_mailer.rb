require_relative '../../lib/tricle/mailer/weekly'
require_relative 'test_metric'
require_relative 'test_metric_with_long_name'

class GroupTestMailer < Tricle::Mailer::Weekly
  default(to: 'recipient1@test.com', from: 'sender@test.com')

  group "Test Group 1" do
    metric TestMetric
  end
  group "Test Group 2" do
    metric TestMetricWithLongName
  end
end
