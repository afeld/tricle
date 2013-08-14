require 'mail_view'
require_relative 'mailer/base'

module Tricle
  class MailPreview < MailView
    Tricle::Mailer::Base.descendants.each do |klass|
      define_method(klass.name.underscore) { klass.email }
    end
  end
end
