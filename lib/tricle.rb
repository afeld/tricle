require 'action_mailer'
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/numeric/time'
require 'active_support/descendants_tracker'

EXCLUDED_FILES = %w(mail_preview.rb tasks.rb).to_set.freeze

dir = File.dirname(__FILE__)
Dir[File.join(dir, 'tricle', '**', '*.rb')].each do |file|
  # MailPreview should be require'd explcitly
  basename = File.basename(file)
  require file unless EXCLUDED_FILES.include?(basename)
end

ActionMailer::Base.view_paths = File.join(dir, 'tricle')

module Tricle
end
