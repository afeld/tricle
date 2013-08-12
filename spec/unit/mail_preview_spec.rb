require 'spec_helper'
require_relative '../app/test_mailer'
require_relative '../../lib/tricle/mail_preview'

describe Tricle::MailPreview do
  describe 'mailer methods' do
    it "should have methods corresponding to all mailers" do
      Tricle::MailPreview.instance_methods(false).should include(:test_mailer)
    end

    it "should return a Mail::Message" do
      Tricle::MailPreview.new.test_mailer.should be_a(Mail::Message)
    end
  end
end
