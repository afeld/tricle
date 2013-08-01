require 'action_mailer'

dir = File.dirname(__FILE__)
Dir[File.join(dir, 'tricle', '**', '*.rb')].each {|file| require file }

ActionMailer::Base.view_paths = File.join(dir, 'tricle')

module Tricle
end
