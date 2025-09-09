module CheckoutRules
  class BogoRuleService
    attr_reader :sku
    def initialize(sku); @sku = sku; end

    def discount(items_count)
      count = items_count[sku] || 0
      return 0 if count < 2

      product = Product.find_by!(code: sku)
      free_units = count / 2
      product.price * free_units
    end
  end
end
