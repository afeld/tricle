require 'action_mailer'

Dir[File.dirname(__FILE__) + '/tricle/**/*.rb'].each {|file| require file }

module Tricle
end
