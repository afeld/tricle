require 'mail_view'

# TODO include add subclasses automatically, and require these in config.ru
require_relative '../../spec/app/test_metric.rb'
require_relative '../../spec/app/test_report.rb'
require_relative '../../spec/app/test_mailer.rb'

module Tricle
  class MailPreview < MailView
    def test_mailer
      TestMailer.email
    end
  end
end
