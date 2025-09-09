require 'rails_helper'

RSpec.describe "Rules API", type: :request do
  let!(:product) { create(:product, code: "SR1", price: 5.0) }
  let!(:rule) { create(:bulk_price_rule, sku: product.code, threshold: 3, new_price: 4.5) }

  it "returns rules" do
    get "/rules"
    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json.first["applies_to"]).to eq("SR1")
    expect(json.first["description"]).to include("Bulk discount")
  end
end
