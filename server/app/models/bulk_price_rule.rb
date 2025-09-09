class BulkPriceRule < PricingRule
  def description
    "Bulk discount: #{threshold}+ for #{'%.2f€' % new_price}"
  end

  def to_rule
    CheckoutRules::BulkPriceRuleService.new(sku, threshold: threshold, new_price: new_price)
  end
end
