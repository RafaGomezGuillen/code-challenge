module CheckoutRules
  class PercentageBulkRuleService
    attr_reader :sku, :threshold, :factor
    def initialize(sku, threshold:, factor:)
      @sku = sku
      @threshold = threshold
      @factor = factor
    end

    def discount(items_count)
      count = items_count[sku] || 0
      return 0 if count < threshold

      product = Product.find_by!(code: sku)
      (product.price * (1 - factor)) * count
    end
  end
end
