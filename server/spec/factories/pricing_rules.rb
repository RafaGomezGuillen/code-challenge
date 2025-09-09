FactoryBot.define do
  factory :bogo_rule, class: "BogoRule" do
    sku { "GR1" }
  end

  factory :bulk_price_rule, class: "BulkPriceRule" do
    sku { "SR1" }
    threshold { 3 }
    new_price { 4.5 }
  end

  factory :percentage_bulk_rule, class: "PercentageBulkRule" do
    sku { "CF1" }
    threshold { 3 }
    factor { 2.0 / 3.0 }
  end
end
