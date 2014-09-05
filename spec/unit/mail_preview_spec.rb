require 'spec_helper'
require_relative '../app/test_mailer'
require_relative '../../lib/tricle/mail_preview'

describe Tricle::MailPreview do
  describe 'mailer methods' do
    it "should have methods corresponding to all mailers" do
      expect(Tricle::MailPreview.instance_methods(false)).to include(:test_mailer)
    end

    it "should return a Mail::Message" do
      mailer = Tricle::MailPreview.new.test_mailer
      expect(mailer.message).to be_a(Mail::Message)
    end
  end
end
