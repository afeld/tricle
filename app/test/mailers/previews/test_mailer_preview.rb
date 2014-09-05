require_relative '../../../../spec/app/test_mailer'
require_relative '../../../../lib/tricle/mailer/methods'

require_relative '../../../../spec/config/timecop'
reset_time

class TestMailerPreview < ActionMailer::Preview
  include Tricle::Mailer::Methods
end
