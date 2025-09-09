require 'rails_helper'

RSpec.describe "CheckoutRules" do
  let!(:product) { create(:product, code: "CF1", price: 11.23) }

  it "BogoRule calculates correct discount" do
    create(:bogo_rule, sku: "CF1")
    rule = CheckoutRules::BogoRuleService.new("CF1")
    expect(rule.discount("CF1" => 2)).to eq(product.price)
  end

  it "BulkPriceRule calculates correct discount" do
    create(:bulk_price_rule, sku: "CF1", threshold: 3, new_price: 4.5)
    rule = CheckoutRules::BulkPriceRuleService.new("CF1", threshold: 3, new_price: 4.5)
    expect(rule.discount("CF1" => 3)).to eq((product.price - 4.5) * 3)
  end

  it "PercentageBulkRule calculates correct discount" do
    create(:percentage_bulk_rule, sku: "CF1", threshold: 3, factor: 2.0/3.0)
    rule = CheckoutRules::PercentageBulkRuleService.new("CF1", threshold: 3, factor: 2.0/3.0)
    expect(rule.discount("CF1" => 3).to_f).to eq((product.price * (1 - 2.0/3.0) * 3).to_f)
  end
end
