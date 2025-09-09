class Checkout
  attr_reader :items, :pricing_rules

  def initialize(pricing_rules: [])
    @pricing_rules = pricing_rules
    @items = []
  end

  def scan(sku)
    raise "Unknown product #{sku}" unless Product.find_by(code: sku)
    @items << sku
  end

  def total
    items_count = @items.tally.transform_values(&:to_i)
    base_total = items_count.sum do |sku, count|
      Product.find_by!(code: sku).price * BigDecimal(count.to_s)
    end

    total_discount = pricing_rules.sum { |rule| rule.discount(items_count) }
    BigDecimal(base_total - total_discount).round(2)
  end

  def format_total
    "%.2f€" % [total.to_f]
  end
end
