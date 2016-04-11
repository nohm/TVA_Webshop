require "rails_helper"

RSpec.describe Mailer, :type => :mailer do
  describe "send_account_activation" do
    let(:mail) { Mailer.send_account_activation }

    it "renders the headers" do
      expect(mail.subject).to eq("Send account activation")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

  describe "send_password_reset" do
    let(:mail) { Mailer.send_password_reset }

    it "renders the headers" do
      expect(mail.subject).to eq("Send password reset")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
