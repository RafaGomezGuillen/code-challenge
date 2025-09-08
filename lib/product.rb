# frozen_string_literal: true
require 'bigdecimal'

class Product
  attr_reader :code, :name, :price

  def initialize(code:, name:, price:)
    @code = code
    @name = name
    @price = BigDecimal(price.to_s)
  end
end
