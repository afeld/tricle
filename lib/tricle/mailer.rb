require 'action_mailer'
require 'active_support/descendants_tracker'
require 'premailer'

require_relative 'email_helper'
require_relative 'presenters/report'
require_relative 'time'

module Tricle
  class Mailer < ActionMailer::Base
    include ActiveSupport::DescendantsTracker

    class_attribute :report
    class_attribute :period
    self.period = :week # or :day, :month
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

      def metric(klass, opts = {})
        self.report.add_metric(klass, opts)
      end

      def list(klass, opts = {}, &block)
        self.report.add_list(klass, opts, &block)
      end

      def send_today?
        time = Tricle::Time.new

        case self.period
        when :day
          true
        when :week
          time.beginning_of_week?
        when :month
          time.beginning_of_month?
        end
      end

      def send_at_period
        send_mailers(Tricle::Mailer.descendants.select(&:send_today?))
      end

      def send_all(with_period = nil)
        klasses = Tricle::Mailer.descendants.select do |klass|
          !with_period || (klass.period == with_period)
        end

        send_mailers(klasses)
      end

      private

      def send_mailers(mailers)
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
