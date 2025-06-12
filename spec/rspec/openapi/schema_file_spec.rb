# frozen_string_literal: true

require 'rspec/openapi/schema_file'
require 'tempfile'
require 'date' # Ensure Date class is available

RSpec.describe RSpec::OpenAPI::SchemaFile do
  describe '#read' do
    let(:tempfile) do
      Tempfile.create(['openapi', '.yml']).tap do |file|
        file.write(<<~YAML)
          openapi: 3.0.0
          info:
            title: My API
            version: 1.0.0
          paths:
            /:
              get:
                summary: A test endpoint
                parameters:
                  - name: date
                    in: query
                    schema:
                      type: string
                      example: 2020-01-02 # Unquoted date
        YAML
        file.rewind
      end
    end

    let(:schema_file) { RSpec::OpenAPI::SchemaFile.new(tempfile.path) }

    # Temporarily make `read` public for testing, then restore its privacy
    around do |example|
      RSpec::OpenAPI::SchemaFile.send(:public, :read)
      example.run
      RSpec::OpenAPI::SchemaFile.send(:private, :read)
    end

    it 'deserializes unquoted dates as Date objects when Date is permitted' do
      data = schema_file.read
      example_date = data.dig(:paths, :/, :get, :parameters, 0, :schema, :example)
      expect(example_date).to be_a(Date)
      expect(example_date).to eq(Date.new(2020, 1, 2))
    end
  end
end
