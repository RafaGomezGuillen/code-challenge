class ProductController < ApplicationController
  # GET /products
  def show
    render json: Product.all
  end
end