# frozen_string_literal: true
require_relative 'product'

module ProductsCatalog
  PRODUCTS = {
    'GR1' => Product.new(code: 'GR1', name: 'Green Tea', price: 3.11),
    'SR1' => Product.new(code: 'SR1', name: 'Strawberries', price: 5.00),
    'CF1' => Product.new(code: 'CF1', name: 'Coffee', price: 11.23)
  }.freeze

  def self.find(code)
    PRODUCTS[code]
  end
end
