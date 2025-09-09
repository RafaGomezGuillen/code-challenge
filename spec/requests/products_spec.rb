require 'rails_helper'

RSpec.describe "Products API", type: :request do
  before { create(:product, code: "GR1", name: "Green Tea", price: 3.11) }

  it "returns products" do
    get "/products"
    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json.first["code"]).to eq("GR1")
  end
end
