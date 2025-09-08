# frozen_string_literal: true
require_relative 'base_rule'
require 'bigdecimal'

class BogoRule < BaseRule
  # @param sku [String]
  def initialize(sku)
    @sku = sku
  end

  # @param items [Hash{String => Integer}]
  # @param catalog [Catalog]
  # @return [BigDecimal]
  def discount(items, catalog)
    count = items.fetch(@sku, 0)
    return BigDecimal('0') if count < 2

    price = catalog.find(@sku).price
    free_units = count / 2
    price * BigDecimal(free_units.to_s)
  end
end
