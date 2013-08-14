require_relative 'test_metric'

class GroupTestMailer < Tricle::Mailer
  default(to: 'recipient1@test.com', from: 'sender@test.com')

  group "Test Group 1" do
    metric TestMetric
  end
  group "Test Group 2" do
    # TODO use different Metric?
    metric TestMetric
  end
end
