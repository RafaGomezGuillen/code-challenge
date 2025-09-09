require 'rails_helper'

RSpec.describe "Checkout API", type: :request do
  let!(:product_gr1) { create(:product, code: "GR1", name: "Green Tea", price: 3.11) }
  let!(:product_sr1) { create(:product, code: "SR1", name: "Strawberries", price: 5.0) }
  let!(:product_cf1) { create(:product, code: "CF1", name: "Coffee", price: 11.23) }

  let!(:bogo) { create(:bogo_rule, sku: "GR1") }
  let!(:bulk) { create(:bulk_price_rule, sku: "SR1", threshold: 3, new_price: 4.5) }
  let!(:percent) { create(:percentage_bulk_rule, sku: "CF1", threshold: 3, factor: 2.0/3.0) }

  before { Cart.destroy_all }

  describe "POST /checkout/scan" do
    it "adds a product to the cart" do
      post "/checkout/scan", params: { code: "GR1" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Added GR1")
    end

    it "returns 404 for unknown product" do
      post "/checkout/scan", params: { code: "XXX" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /checkout" do
    before do
      2.times { post "/checkout/scan", params: { code: "GR1" } } # BOGO
    end

    it "returns the cart items and total" do
      get "/checkout"
      json = JSON.parse(response.body)

      expect(json["items"].map { |i| i["code"] }).to include("GR1")
      expect(json["total"]).to eq("3.11€")
    end
  end

  describe "GET /checkout" do
    before do
      1.times { post "/checkout/scan", params: { code: "GR1" } } # BOGO
      3.times { post "/checkout/scan", params: { code: "SR1" } } # Bulk discount: 3+ for 4.50€
    end

    it "returns the cart items and total" do
      get "/checkout"
      json = JSON.parse(response.body)

      expect(json["items"].map { |i| i["code"] }).to include("GR1", "SR1")
      expect(json["total"]).to eq("16.61€")
    end
  end

  describe "GET /checkout" do
    before do
      1.times { post "/checkout/scan", params: { code: "GR1" } } # BOGO
      1.times { post "/checkout/scan", params: { code: "SR1" } } # Bulk discount: 3+ for 4.50€
      3.times { post "/checkout/scan", params: { code: "CF1" } } # Bulk discount: 3+ get 33% off
    end

    it "returns the cart items and total" do
      get "/checkout"
      json = JSON.parse(response.body)

      expect(json["items"].map { |i| i["code"] }).to include("GR1", "SR1", "CF1")
      expect(json["total"]).to eq("30.57€")
    end
  end

  describe "GET /products" do
    it "returns all products" do
      get "/products"
      json = JSON.parse(response.body)
      expect(json.size).to eq(3)
    end
  end

  describe "GET /rules" do
    it "returns all pricing rules with description" do
      get "/rules"
      json = JSON.parse(response.body)
      expect(json.size).to eq(3)
      expect(json.map { |r| r["description"] }).to include("Buy One Get One Free")
    end
  end

  describe "DELETE /checkout" do
    it "clears the current cart" do
      post "/checkout/scan", params: { code: "GR1" }
      expect(Cart.first.cart_items.count).to eq(1)

      delete "/checkout"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("Checkout cleared")

      get "/checkout"
      json = JSON.parse(response.body)
      expect(json["items"]).to be_empty
      expect(json["total"]).to eq("0.00€")
    end
  end
end
