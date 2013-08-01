require 'action_mailer'
require 'active_support/core_ext/date/calculations'
require 'active_support/core_ext/numeric/time'

dir = File.dirname(__FILE__)
Dir[File.join(dir, 'tricle', '**', '*.rb')].each {|file| require file }

ActionMailer::Base.view_paths = File.join(dir, 'tricle')

module Tricle
end
