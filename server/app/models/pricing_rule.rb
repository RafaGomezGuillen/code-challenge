class PricingRule < ApplicationRecord
  # STI: type = "BogoRule", "BulkPriceRule", "PercentageBulkRule"
  validates :sku, presence: true
end
