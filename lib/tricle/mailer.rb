require_relative 'email_helper'

module Tricle
  class Mailer < ActionMailer::Base
    include ActiveSupport::DescendantsTracker

    attr_reader :report_instance
    helper Tricle::EmailHelper

    CSS = File.read(File.join(File.dirname(__FILE__), 'templates', 'email.css')).freeze


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

    def premailer(message)
      # message.text_part.body = Premailer.new(message.text_part.body.to_s, with_html_string: true).to_plain_text
      message.html_part.body = Premailer.new(message.html_part.body.to_s, css_string: CSS.dup, with_html_string: true).to_inline_css
      message
    end

    def email(options = {})
      options = {
        subject: self.subject
      }.merge(options)

      @metrics = self.metric_instances

      message = mail(options) do |format|
        format.html { render 'templates/email' }
        format.text { render 'templates/email' }
      end

      premailer(message)
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
