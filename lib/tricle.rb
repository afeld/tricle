require 'action_mailer'
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/numeric/time'
require 'active_support/descendants_tracker'
require 'premailer'

dir = File.dirname(__FILE__)
Dir[File.join(dir, 'tricle', '**', '*.rb')].each do |file|
  # MailPreview should be require'd explcitly
  require file unless file.end_with?('mail_preview.rb')
end

ActionMailer::Base.view_paths = File.join(dir, 'tricle')

module Tricle
end
