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
    desc "Send a specific email, or all emails"
    task :send, [:email_string] do |t, args|
      if (str = args[:email_string])
        str.split(":").each do |email_klass|
          (email_klass.constantize).email.deliver
        end
      else
        Tricle::Mailer.send_all
      end
    end
  end
end
