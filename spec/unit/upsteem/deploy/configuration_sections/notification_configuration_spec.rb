require "spec_helper"

describe Upsteem::Deploy::ConfigurationSections::NotificationConfiguration do
  let(:credentials) { { param1: "123", param2: "456abc", param3: "asdf" } }
  let(:url_template) { "https://deploy.notification.host.com/path/%<param1>s/new?something=%<param2>s" }
  let(:repository) { "https://repo.host/path/to/repo" }

  let(:data) do
    {
      credentials: credentials,
      deploy: {
        url_template: url_template,
        repository: repository,
        other: { a: :b }
      }
    }
  end

  let(:section) { described_class.new(data) }

  shared_examples_for "unmodifiable string" do
    it "is frozen" do
      expect { subject << "asdf" }.to raise_error(RuntimeError, "can't modify frozen String")
    end
  end

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

    it_behaves_like "unmodifiable string"
  end

  describe "#repository" do
    subject { section.repository }

    it { is_expected.to eq(repository) }

    it_behaves_like "unmodifiable string"
  end
end
