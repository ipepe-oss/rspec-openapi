# frozen_string_literal: true

require 'spec_helper'
require 'tempfile'
require 'date'

RSpec.describe RSpec::OpenAPI::SchemaFile do
  include SpecHelper

  it 'reads YAML with Date objects' do
    Tempfile.create(['openapi', '.yaml']) do |file|
      file.write("date: 2024-05-10\n")
      file.close
      loaded_schema = nil
      RSpec::OpenAPI::SchemaFile.new(file.path).edit do |spec|
        loaded_schema = spec
      end
      expect(loaded_schema).to eq(date: Date.new(2024, 5, 10))
    end
  end
end
