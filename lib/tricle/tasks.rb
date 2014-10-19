require 'rack'
require 'rake'
require_relative '../tricle'

namespace :tricle do
  desc "Start a local server to preview your mailers"
  task :preview do
    require_relative 'mail_preview'

    Rack::Server.start app: Tricle::MailPreview
  end

  namespace :emails do
    desc "Send all emails"
    task :send do
      Tricle::Mailer.send_all
    end

    task :daily do
      Tricle::Mailer.send(:day)
    end

    task :weekly do
      Tricle::Mailer.send(:week)
    end

    task :monthly do
      Tricle::Mailer.send(:month)
    end

    # needed for Heroku Scheduler, whose most infrequent option is daily
    task :send_at_period do
      Tricle::Mailer.send_at_period
    end

    # Backwards-compatibility
    task send_after_beginning_of_week: [:send_at_period]
  end
end
