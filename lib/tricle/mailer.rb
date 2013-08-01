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

    def metrics
      self.report.new.metrics
    end

    def values
      self.metrics.map do |metric|
        # TODO pass the times in for real
        metric.new.for_range(Time.now, Time.now)
      end
    end

    def email(options = {})
      options = {
        subject: self.subject,
        template_path: 'templates'
      }.merge(options)

      @values = self.values

      mail(options)
    end
  end
end
