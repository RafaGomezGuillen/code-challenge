# frozen_string_literal: true

require_relative '../checkout'
require_relative '../pricing_rules/bogo_rule'
require_relative '../pricing_rules/bulk_price_rule'
require_relative '../pricing_rules/percentage_bulk_rule'
require_relative 'helpers'
require_relative 'menu_helper'

class CashRegisterCLI
  include CLIHelpers
  include MenuHelper

  def initialize
    rules = [
      BogoRule.new('GR1'),
      BulkPriceRule.new('SR1', threshold: 3, new_price: 4.5),
      PercentageBulkRule.new('CF1', threshold: 3, factor: (2.0 / 3.0)),
    ]
    @checkout = Checkout.new(pricing_rules: rules)
  end

  def start
    loop do
      clear_console
      print_menu
      choice = gets&.strip
      break unless choice
      case choice
      when '1' then add_product
      when '2' then show_basket
      when '3' then show_options(@checkout)
      when '0'
        puts 'Goodbye!'
        break
      else
        puts 'Invalid option. Please try again.'
      end
      pause_and_clear
    end
  end

  private

  def add_product
    show_options(@checkout)

    print "\nEnter product code: "
    code = gets&.strip.upcase
    return unless code

    begin
      @checkout.scan(code)
      puts "Added #{code}"
    rescue => e
      puts "Error: #{e.message}"
    end
  end

  def show_basket
    if @checkout.items.empty?
      puts 'Basket is empty'
    else
      counts = @checkout.items.tally
      width = 50

      puts 'Your Basket:'
      puts '-' * width
      printf("%-10s %-20s %5s %10s\n", 'CODE', 'PRODUCT', 'QTY', 'SUBTOTAL')
      puts '-' * width

      total = BigDecimal('0')
      counts.each do |sku, qty|
        product = ProductsCatalog.find(sku)
        subtotal = product.price * qty
        total += subtotal
        printf("%-10s %-20s %5d %10.2f€\n", sku, product.name, qty, subtotal.to_f)
      end

      puts '-' * width
      puts "Total with discounts: #{@checkout.format_total}"
    end
  end
end
