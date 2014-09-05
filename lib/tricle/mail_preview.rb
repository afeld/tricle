require 'mail_view'
require_relative 'mailer'
require_relative 'mailer/methods'

module Tricle
  class MailPreview < MailView
    include Tricle::Mailer::Methods
  end
end
