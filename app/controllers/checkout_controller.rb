class CheckoutController < ApplicationController
  before_action :set_cart

  # GET /checkout
  def show
    items = @cart.cart_items.includes(:product).map do |item|
      {
        code: item.product.code,
        name: item.product.name,
        price: item.product.price.to_f,
        quantity: item.quantity
      }
    end

    render json: { items: items, total: @cart.total }
  end

  # POST /checkout/scan
  def scan
    code = params[:code]&.upcase
    @cart.add_product(code)
    render json: { message: "Added #{code}" }
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: :not_found
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.record.errors.full_messages.join(", ") }, status: :unprocessable_content
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  # DELETE /checkout
  def destroy
    @cart.destroy!
    render json: { message: "Checkout cleared" }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_cart
    @cart = Cart.first_or_create!
  end
end
