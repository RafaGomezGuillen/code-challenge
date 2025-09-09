class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def add_product(product_code)
    product = Product.find_by!(code: product_code)
    item = cart_items.find_or_initialize_by(product: product)
    item.quantity ||= 0
    item.quantity += 1
    item.save!
  end


  def total
    checkout = Checkout.new(pricing_rules: PricingRule.all.map(&:to_rule))
    cart_items.each do |item|
      item.quantity.times { checkout.scan(item.product.code) }
    end
    checkout.format_total
  end
end
