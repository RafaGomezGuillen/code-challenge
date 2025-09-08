# frozen_string_literal: true

module MenuHelper
  # Print the main menu
  def print_menu
    puts '=== Welcome to Cash Register CLI ==='
    puts "\nChoose an option:"
    puts '1. Add product to basket'
    puts '2. Show basket contents and total'
    puts '3. Help'
    puts '0. Exit'
    print '> '
  end

  # Show available products with pricing rules
  def show_options(checkout)
    puts "\n=== Available Products ==="
    ProductsCatalog::PRODUCTS.each do |code, product|
      description = rule_description_for(code, checkout)
      puts "  #{code} - #{product.name} (#{'%.2f€' % product.price}) #{description}"
    end
  end

  private

  # Get description of pricing rules for a product code
  def rule_description_for(code, checkout)
    rules = checkout.instance_variable_get(:@pricing_rules)
    descs = rules.map do |rule|
      case rule
      when BogoRule
        "→ Buy One Get One Free" if rule.instance_variable_get(:@sku) == code
      when BulkPriceRule
        if rule.instance_variable_get(:@sku) == code
          threshold = rule.instance_variable_get(:@threshold)
          new_price = rule.instance_variable_get(:@new_price)
          "→ Bulk discount: #{threshold}+ for #{'%.2f€' % new_price}"
        end
      when PercentageBulkRule
        if rule.instance_variable_get(:@sku) == code
          threshold = rule.instance_variable_get(:@threshold)
          factor = rule.instance_variable_get(:@factor)
          perc = ((1 - factor.to_f) * 100).round
          "→ Bulk discount: #{threshold}+ get #{perc}% off"
        end
      end
    end.compact

    descs.empty? ? '' : descs.join(', ')
  end
end
