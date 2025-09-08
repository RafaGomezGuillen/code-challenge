# frozen_string_literal: true
require 'bigdecimal'
require_relative 'products_catalog'

class Checkout
  attr_reader :items

  # pricing_rules: array of pricing rule instances
  def initialize(pricing_rules: [])
    @pricing_rules = pricing_rules
    @items = []
  end

  # raises if sku is unknown
  def scan(sku)
    raise "Unknown product #{sku}" unless ProductsCatalog.find(sku)

    @items << sku
  end

  # returns total as BigDecimal rounded to 2 decimal places
  def total
    items_count = @items.each_with_object(Hash.new(0)) { |sku, h| h[sku] += 1 }

    base_total = items_count.sum do |sku, count|
      ProductsCatalog.find(sku).price * BigDecimal(count.to_s)
    end

    total_discount = @pricing_rules.sum do |rule|
      rule.discount(items_count, ProductsCatalog)
    end

    result = base_total - total_discount
    BigDecimal(result.to_s).round(2)
  end

  # returns total as formatted string with 2 decimals and euro symbol
  def format_total
    amt = total

    "%.2f€" % [amt.to_f]
  end
end
