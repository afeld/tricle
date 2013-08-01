module Tricle
  class Mailer < ActionMailer::Base
    def frequency
      raise Tricle::AbstractMethodError.new
    end

    def report
      raise Tricle::AbstractMethodError.new
    end

    def subject
      "Your #{self.class.name.titleize}"
    end

    def email(options = {})
      options = {
        subject: self.subject,
        template_path: 'templates'
      }.merge(options)

      mail(options)
    end
  end
end
