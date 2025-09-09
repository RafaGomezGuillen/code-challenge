class RuleController < ApplicationController
  # GET /rules
  def show
    render json: PricingRule.all.map { |rule|
      { applies_to: rule.sku, description: rule.description }
    }
  end
end