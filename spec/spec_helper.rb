require 'bundler/setup'

Dir[File.join(File.dirname(__FILE__), '..', 'lib', '**', '*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
end
