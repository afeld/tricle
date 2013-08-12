class GroupTestMailer < Tricle::Mailer
  default(to: 'recipient1@test.com', from: 'sender@test.com')

  group "Test Group" do
    metric TestMetric
  end
end
