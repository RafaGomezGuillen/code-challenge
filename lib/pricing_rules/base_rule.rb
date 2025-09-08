# frozen_string_literal: true

class BaseRule
  # @param items [Array<Item>]
  # @param catalog [Catalog]
  # @return [BigDecimal]
  def discount(items, catalog)
    BigDecimal('0')
  end
end
