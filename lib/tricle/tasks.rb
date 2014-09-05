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

    # needed for Heroku Scheduler, whose most infrequent option is daily
    desc "Send all emails, but only if it's the current day is the \"beginning of the week\". See http://api.rubyonrails.org/classes/Date.html#method-i-beginning_of_week-3D."
    task :send_after_beginning_of_week do
      Tricle::Mailer.send_all_if_beginning_of_week
    end
  end
end
