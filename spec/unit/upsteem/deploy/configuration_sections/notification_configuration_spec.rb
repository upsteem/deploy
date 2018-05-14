require "spec_helper"

describe Upsteem::Deploy::ConfigurationSections::NotificationConfiguration do
  let(:url_template) { "https://deploy.notification.host.com/path/%<param1>s/new?something=%<param2>s" }
  let(:credentials) { { param1: "123", param2: "456abc", param3: "asdf" } }
  let(:data) do
    {
      deploy_notification_url_template: url_template,
      credentials: credentials,
      other: { a: :b }
    }
  end

  let(:section) { described_class.new(data) }

  describe ".new" do
    subject { section }

    it { is_expected.to be_instance_of(described_class) }

    context "when url template missing" do
      shared_examples_for "error on missing url template" do |blank_url_template|
        let(:url_template) { blank_url_template }

        it_behaves_like "exception raiser", ArgumentError, "URL template not given in configuration data"
      end

      it_behaves_like "error on missing url template", nil
      it_behaves_like "error on missing url template", ""
    end

    context "when credentials missing" do
      shared_examples_for "error on missing credentials" do |blank_credentials|
        let(:credentials) { blank_credentials }

        it_behaves_like "exception raiser", ArgumentError, "Credentials not given in configuration data"
      end

      it_behaves_like "error on missing credentials", nil
      it_behaves_like "error on missing credentials", {}
    end
  end

  describe "#url" do
    subject { section.url }

    let(:expected_url) { "https://deploy.notification.host.com/path/123/new?something=456abc" }

    it { is_expected.to eq(expected_url) }
  end
end
