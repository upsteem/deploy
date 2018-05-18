require "spec_helper"
Upsteem::Deploy::SpecHelperLoader.require_shared_contexts_for("unit/logger")

describe Upsteem::Deploy::Services::Notifier do
  include_context "setup for logger"

  # Using a localhost URL to avoid outgoing requests just in case when WebMock unexpectedly does not intercept:
  let(:url) { "http://localhost:3000/deploy/notifications/receive" }
  let(:environment_name) { "someenv" }
  let(:user_name) { "John Smith" }
  let(:repository) { "https://github.com/upsteem/somerepo" }
  let(:revision) { "3dde365b8b51c1620be2f515aef1868c52ffdb2d" }

  let(:connection_settings) { { url: url } }
  let(:request_headers) { { "Content-Type" => "application/json" } }

  let(:request_body) do
    {
      environment: environment_name,
      username: user_name,
      repository: repository,
      revision: revision
    }.to_json
  end

  let(:request_occurrences) { 1 }

  let(:http_timeout) { false }
  let(:http_response_status) { 200 }
  let(:http_response_body) { "OK" }

  let(:configuration) { instance_double("Upsteem::Deploy::ConfigurationSections::NotificationConfiguration") }
  let(:environment) { instance_double("Upsteem::Deploy::Environment") }
  let(:logger) { instance_double("Logger") }
  let(:git) { instance_double("Upsteem::Deploy::Services::Git") }

  let(:notifier) do
    described_class.new(configuration, environment, logger, git)
  end

  def stub_url_from_configuration
    allow(configuration).to receive(:url).and_return(url)
  end

  def stub_repository_from_configuration
    allow(configuration).to receive(:repository).and_return(repository)
  end

  def stub_name_from_environment
    allow(environment).to receive(:name).and_return(environment_name)
  end

  def stub_user_name_from_git
    allow(git).to receive(:user_name).and_return(user_name)
  end

  def stub_head_revision_from_git
    allow(git).to receive(:head_revision).and_return(revision)
  end

  def stub_notification_request
    request_stub = stub_request(:post, url)
    if http_timeout
      request_stub.to_timeout
    else
      request_stub.to_return(status: http_response_status, body: http_response_body)
    end
  end

  def expect_result_logging
    expect_logger_info("Response status: #{http_response_status}")
    expect_logger_info("Response body: #{http_response_body}")
  end

  shared_context "no result logging" do
    def expect_result_logging; end
  end

  # Override where necessary.
  def expect_error_logging; end

  shared_context "error logging" do
    def expect_error_logging
      expect_logger_action(:error, logger_error_message)
    end
  end

  def validate_notification_request
    data = {
      body: request_body,
      headers: { "Content-Type" => "application/json" }
    }
    expect(a_request(:post, url).with(data)).to have_been_made.times(request_occurrences)
  end

  describe "#notify" do
    subject { notifier.notify }

    def stub_service_data
      stub_url_from_configuration
      stub_repository_from_configuration
      stub_name_from_environment
      stub_user_name_from_git
      stub_head_revision_from_git
      stub_notification_request
    end

    def expect_events
      expect_logger_info("Connection settings: #{connection_settings.inspect}")
      expect_logger_info("Request body: #{request_body}")
      expect_result_logging
      expect_error_logging
    end

    before do
      stub_service_data
      expect_events
    end

    after do
      validate_notification_request
    end

    it { is_expected.to eq(true) }

    context "when HTTP response status is in 2xx range but not 200" do
      let(:http_response_status) { 201 }

      it { is_expected.to eq(true) }
    end

    context "when HTTP response status is not OK" do
      include_context "error logging"

      let(:http_response_status) { 500 }
      let(:http_response_body) { "Something went wrong" }
      let(:logger_error_message) { "Bad HTTP response status: #{http_response_status}" }

      it { is_expected.to eq(false) }
    end

    context "when HTTP request times out" do
      include_context "no result logging"
      include_context "error logging"

      let(:http_timeout) { true }
      let(:logger_error_message) do
        "HTTP connection error occurred: Faraday::ConnectionFailed (execution expired)"
      end

      it { is_expected.to eq(false) }
    end

    context "when configuration is missing" do
      let(:configuration) { nil }
      let(:request_occurrences) { 0 }

      def stub_service_data; end

      def expect_events; end

      it { is_expected.to be_nil }
    end
  end
end
