#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'

# Run tests if 'test' is the first argument
if ARGV.first == 'test'
  exec('bundle exec rspec')
end

require_relative '../lib/cli/cash_register_cli'

CashRegisterCLI.new.start
