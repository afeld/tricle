require_relative '../../lib/tricle/mailer/weekly'
require_relative 'test_metric'

class ListTestMailer < Tricle::Mailer::Weekly
  default(to: 'recipient1@test.com', from: 'sender@test.com')

  list TestMetric do |val|
    sprintf('%.1f', val)
  end
end
