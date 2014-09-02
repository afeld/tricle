require 'rack'
require 'rake'
require 'rails'
require_relative '../tricle'
require_relative '../../previewer/lib/previewer'

namespace :tricle do
  desc "Start a local server to preview your mailers"
  task :preview do
    require_relative 'mail_preview'

    Rack::Server.start app: Previewer::Engine
  end

  namespace :emails do
    desc "Send all emails"
    task :send do
      Tricle::Mailer.send_all
    end
  end
end
