module CheckoutRules
  class BulkPriceRuleService
    attr_reader :sku, :threshold, :new_price
    def initialize(sku, threshold:, new_price:)
      @sku = sku
      @threshold = threshold
      @new_price = new_price
    end

    def discount(items_count)
      count = items_count[sku] || 0
      return 0 if count < threshold

      product = Product.find_by!(code: sku)
      (product.price - new_price) * count
    end
  end
end
