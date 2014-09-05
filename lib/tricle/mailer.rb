require 'action_mailer'
require 'active_support/descendants_tracker'
require 'premailer'

require_relative 'email_helper'
require_relative 'presenters/report'


module Tricle
  class Mailer < ActionMailer::Base
    include ActiveSupport::DescendantsTracker

    class_attribute :report
    helper Tricle::EmailHelper
    self.view_paths = File.dirname(__FILE__)

    CSS = File.read(File.join(File.dirname(__FILE__), 'templates', 'email.css')).freeze


    def subject
      "Your #{self.class.name.titleize}"
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

      @report = self.report

      message = mail(options) do |format|
        format.html { render 'templates/email' }
        format.text { render 'templates/email' }
      end

      premailer(message)
    end

    class << self
      def inherited(klass)
        klass.report = Tricle::Presenters::Report.new
        super(klass)
      end

      def group(title)
        self.report.add_group(title)
        yield if block_given?
      end

      def metric(klass)
        self.report.add_metric(klass)
      end

      def list(klass, &block)
        self.report.add_list(klass, &block)
      end

      def send_all
        mailers = Tricle::Mailer.descendants
        puts "Sending #{mailers.size} emails..."
        mailers.each do |klass|
          puts "Sending #{klass.name}..."
          klass.email.deliver
        end
        puts "Done."
      end

      def current_day_of_week
        Time.now.strftime('%A').downcase.to_sym
      end

      def beginning_of_week
        # Rails >= 4.0.2
        # http://apidock.com/rails/v4.0.2/Date/beginning_of_week/class
        Date.try(:beginning_of_week) || :monday
      end

      def send_all_if_beginning_of_week
        if self.current_day_of_week == self.beginning_of_week
          self.send_all
        else
          puts "Skipping send, because it's not the beginning of the week."
        end
      end
    end
  end
end
