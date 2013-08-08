require 'rake'
require_relative '../tricle.rb'

namespace :tricle do
  namespace :emails do
    desc "Send all emails"
    task :send do
      Tricle::Mailer.send_all
    end
  end
end
