require 'rake'

namespace :tricle do
  desc "Start a local server to preview your mailers"
  task :preview do
    require 'rack'
    require_relative 'mail_preview'
    Rack::Server.start app: Tricle::MailPreview
  end

  namespace :emails do
    desc "Send all emails"
    task :send do
      require_relative 'mailer/base'
      Tricle::Mailer::Base.send_all
    end
  end
end
