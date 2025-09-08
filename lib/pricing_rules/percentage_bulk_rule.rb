# frozen_string_literal: true
require_relative 'base_rule'
require 'bigdecimal'

class PercentageBulkRule < BaseRule
  # @param sku [String]
  # @param threshold [Integer]
  # @param factor [BigDecimal]
  def initialize(sku, threshold:, factor:)
    @sku = sku
    @threshold = threshold
    @factor = BigDecimal(factor.to_s)
  end

  # @param items [Hash{String => Integer}]
  # @param catalog [Catalog]
  # @return [BigDecimal]
  def discount(items, catalog)
    count = items.fetch(@sku, 0)
    return BigDecimal('0') if count < @threshold

    original = catalog.find(@sku).price
    new_price = (original * @factor)
    (original - new_price) * BigDecimal(count.to_s)
  end
end
