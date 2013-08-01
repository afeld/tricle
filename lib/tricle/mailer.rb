module Tricle
  class Mailer < ActionMailer::Base
    def frequency
      raise Tricle::AbstractMethodError.new
    end

    def report
      raise Tricle::AbstractMethodError.new
    end

    def deliver
      subject = "Your #{self.class.name.titleize}"
      mail(subject: subject, body: '').deliver
    end
  end
end
