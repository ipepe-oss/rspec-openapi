# frozen_string_literal: true

require 'spec_helper'
require 'tmpdir'

RSpec.describe RSpec::OpenAPI::SchemaFile do
  include SpecHelper

  it 'reads YAML with unquoted date' do
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'openapi.yml')
      File.write(path, <<~YAML)
        updated_at: 2025-06-10 01:47:28Z
      YAML
      schema_file = described_class.new(path)
      result = schema_file.send(:read)
      expect(result[:updated_at]).to eq(Time.utc(2025, 6, 10, 1, 47, 28))
    end
  end
end
