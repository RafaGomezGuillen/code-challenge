class PercentageBulkRule < PricingRule
  def description
    perc = ((1 - factor.to_f) * 100).round
    "Bulk discount: #{threshold}+ get #{perc}% off"
  end

  def to_rule
    CheckoutRules::PercentageBulkRuleService.new(sku, threshold: threshold, factor: factor)
  end
end
