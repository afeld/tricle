require 'action_mailer'
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/numeric/time'
require 'active_support/descendants_tracker'
require 'premailer'

EXCLUDED_FILES = %w(mail_preview.rb tasks.rb).to_set.freeze

dir = File.dirname(__FILE__)
# ensure the files always load in a consistent order
Dir[File.join(dir, 'tricle', '**', '*.rb')].sort.each do |file|
  # MailPreview should be require'd explcitly
  basename = File.basename(file)
  require file unless EXCLUDED_FILES.include?(basename)
end

ActionMailer::Base.view_paths = File.join(dir, 'tricle')

module Tricle
end
