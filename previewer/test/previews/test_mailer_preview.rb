require_relative '../../../../spec/app/test_mailer'
require_relative '../../../../spec/config/timecop'

reset_time

class TestMailerPreview < ActionMailer::Preview
  def email
    TestMailer.email
  end
end
