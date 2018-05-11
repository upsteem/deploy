require "spec_helper"

describe Upsteem::Deploy::Builders::HttpRequest do
  let(:url) { "https://example.org/path/to/something" }
  let(:url_arg) { url }
  let(:http_method) { :post }
  let(:http_method_arg) { http_method }

  let(:build_result) do
    described_class.build do |builder|
      add_url(builder)
      add_http_method(builder)
      add_header(builder)
      add_content_type(builder)
      add_param(builder)
    end
  end

  def add_url(builder)
    builder.url(url_arg)
  end

  def add_http_method(builder)
    builder.http_method(http_method_arg)
  end

  def add_header(builder); end

  def add_content_type(builder); end

  def add_param(builder); end

  describe ".build" do
    shared_examples_for "missing URL exception raiser" do
      it "raises an exception" do
        expect { build_result }.to raise_error(RuntimeError, "URL not set during build")
      end
    end

    shared_examples_for "missing HTTP method exception raiser" do
      it "raises an exception" do
        expect { build_result }.to raise_error(RuntimeError, "HTTP method not set during build")
      end
    end

    it "returns an instance of the corresponding model" do
      expect(build_result).to be_instance_of(Upsteem::Deploy::Models::HttpRequest)
    end

    context "when URL skipped" do
      def add_url(builder); end
      it_behaves_like "missing URL exception raiser"
    end

    context "when blank URL used" do
      let(:url) { "" }
      it_behaves_like "missing URL exception raiser"
    end

    context "when HTTP method skipped" do
      def add_http_method(builder); end
      it_behaves_like "missing HTTP method exception raiser"
    end

    context "when blank HTTP method used" do
      let(:http_method) { "" }
      it_behaves_like "missing HTTP method exception raiser"
    end
  end

  describe "#url" do
    it "adds the URL to the model instance" do
      expect(build_result.url).to eq(url)
    end
  end

  describe "#http_method" do
    it "adds the HTTP method to the model instance" do
      expect(build_result.http_method).to eq(http_method)
    end
  end

  describe "#header" do
    let(:header_name) { "Some-Header" }
    let(:header_name_arg) { header_name }

    let(:header_value) { "some/value" }
    let(:header_value_arg) { header_value }

    def add_header(builder)
      builder.header(header_name_arg, header_value_arg)
    end

    shared_examples_for "formatter and adder" do
      it "adds the header with stringified name to the model instance" do
        expect(build_result.headers).to eq(header_name => header_value)
      end
    end

    it_behaves_like "formatter and adder"

    context "when header name is not a string" do
      let(:header_name_arg) { :SomeHeader }
      let(:header_name) { "SomeHeader" }

      it_behaves_like "formatter and adder"
    end
  end

  describe "#content_type" do
    let(:content_type) { "application/json" }
    let(:content_type_arg) { content_type }

    def add_content_type(builder)
      builder.content_type(content_type_arg)
    end

    it "adds content type header to the model instance" do
      expect(build_result.headers).to eq("Content-Type" => content_type)
    end
  end

  describe "#param" do
    let(:param_name) { :some_param }
    let(:param_name_arg) { param_name }

    let(:param_value) { "some value" }
    let(:param_value_arg) { param_value }

    def add_param(builder)
      builder.param(param_name_arg, param_value_arg)
    end

    shared_examples_for "formatter and adder" do
      it "adds the param with symbolized name to the model instance" do
        expect(build_result.params).to eq(param_name => param_value)
      end
    end

    it_behaves_like "formatter and adder"

    context "when param name is not a symbol" do
      let(:param_name_arg) { "some_param" }
      it_behaves_like "formatter and adder"
    end
  end
end
