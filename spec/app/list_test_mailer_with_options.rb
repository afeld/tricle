require_relative '../../lib/tricle/mailer'
require_relative 'test_metric'

class ListTestMailerWithOptions < Tricle::Mailer
  default(to: 'recipient1@test.com', from: 'sender@test.com')

  list TestMetric, title: 'TheNewTitle' do |val|
    sprintf('%.1f', val)
  end
end
