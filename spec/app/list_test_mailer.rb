class ListTestMailer < Tricle::Mailer
  default(to: 'recipient1@test.com', from: 'sender@test.com')

  list TestMetric do |val|
    sprintf('%.1f', val)
  end
end
