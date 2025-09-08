# frozen_string_literal: true
require_relative 'base_rule'
require 'bigdecimal'

class BulkPriceRule < BaseRule
  # @param sku [String]
  # @param threshold [Integer]
  # @param new_price [BigDecimal]
  def initialize(sku, threshold:, new_price:)
    @sku = sku
    @threshold = threshold
    @new_price = BigDecimal(new_price.to_s)
  end

  # @param items [Hash{String => Integer}]
  # @param catalog [Catalog]
  # @return [BigDecimal]
  def discount(items, catalog)
    count = items.fetch(@sku, 0)
    return BigDecimal('0') if count < @threshold

    original = catalog.find(@sku).price
    discount_per_unit = original - @new_price
    discount_per_unit * BigDecimal(count.to_s)
  end
end
