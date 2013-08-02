require './lib/tricle.rb'
require './spec/app/test_metric.rb'
require './spec/app/test_report.rb'
require './spec/app/test_mailer.rb'

run lambda { |env|
  [200, {}, [TestMailer.email.parts.first.body.raw_source]]
}
