require 'rails_helper'

RSpec.describe Cart, type: :model do
  let!(:cart) { create(:cart) }
  let!(:product) { create(:product, code: "CF1", price: 11.23) }

  it "adds product to cart" do
    expect { cart.add_product("CF1") }.to change { cart.cart_items.count }.by(1)
    item = cart.cart_items.first
    expect(item.quantity).to eq(1)
  end

  it "increments quantity if product already in cart" do
    cart.add_product("CF1")
    cart.add_product("CF1")
    item = cart.cart_items.first
    expect(item.quantity).to eq(2)
  end

  it "calculates total with discount" do
    create(:percentage_bulk_rule, sku: "CF1", threshold: 3, factor: 2.0/3.0)
    3.times { cart.add_product("CF1") }
    expect(cart.total).to eq("22.46€")
  end
end
