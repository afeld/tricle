require './lib/tricle.rb'

require './spec/app/test_metric.rb'
require './spec/app/test_mailer.rb'
require './spec/app/group_test_mailer.rb'

require 'tricle/mail_preview'

run Tricle::MailPreview
