require 'mail_view'

module Tricle
  class MailPreview < MailView
    Tricle::Mailer.descendants.each do |klass|
      define_method(klass.name.underscore) { klass.email }
    end
  end
end
