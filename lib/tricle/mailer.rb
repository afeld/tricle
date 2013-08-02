module Tricle
  class Mailer < ActionMailer::Base
    include ActiveSupport::DescendantsTracker

    attr_reader :report_instance
    helper Tricle::EmailHelper

    def initialize(*args)
      @report_instance = self.report.new
      super(*args)
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
        subject: self.subject
      }.merge(options)

      @metrics = self.metric_instances

      mail(options) do |format|
        format.html { render 'templates/email' }
        format.text { render 'templates/email' }
      end
    end

    class << self
      def send_all
        mailers = Tricle::Mailer.descendants
        puts "Sending #{mailers.size} emails..."
        mailers.each do |klass|
          puts "Sending #{klass.name}..."
          klass.email.deliver
        end
        puts "Done."
      end
    end
  end
end
