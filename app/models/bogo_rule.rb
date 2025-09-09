class BogoRule < PricingRule
  def description
    "Buy One Get One Free"
  end

  def to_rule
    CheckoutRules::BogoRuleService.new(sku)
  end
end
