require 'john_stamos'
require 'john_stamos/pin_search'
require 'john_stamos/pin'
require 'john_stamos/pinner'
require 'john_stamos/client'
require 'john_stamos/extraction_helper'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/support/vcr_cassettes'
  c.hook_into :webmock
  c.default_cassette_options = { :record => :once }
  c.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.order = 'random'

  config.treat_symbols_as_metadata_keys_with_true_values = true
end