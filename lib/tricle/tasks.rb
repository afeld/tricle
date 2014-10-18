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

    # Backwards-compatibility
    task send_after_beginning_of_week: [:send]

    task :send_now do
      Tricle::Mailer.send_now
    end
  end
end
