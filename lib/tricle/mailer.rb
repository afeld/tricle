module Tricle
  class Mailer < ActionMailer::Base
    include ActiveSupport::DescendantsTracker

    attr_reader :report_instance

    def initialize(*args)
      @report_instance = self.report.new
      super(*args)
    end


    def frequency
      raise Tricle::AbstractMethodError.new
    end

    def report
      raise Tricle::AbstractMethodError.new
    end

    def subject
      "Your #{self.class.name.titleize}"
    end


    def metric_instances
      self.report_instance.metric_instances
    end

    def email(options = {})
      options = {
        subject: self.subject,
        template_path: 'templates'
      }.merge(options)

      @metrics = self.metric_instances

      mail(options)
    end
  end
end
