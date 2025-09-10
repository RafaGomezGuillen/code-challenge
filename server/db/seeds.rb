# Products
Product.find_or_create_by!(code: "GR1") { |p| p.name = "Green Tea"; p.price = 3.11 }
Product.find_or_create_by!(code: "SR1") { |p| p.name = "Strawberries"; p.price = 5.00 }
Product.find_or_create_by!(code: "CF1") { |p| p.name = "Coffee"; p.price = 11.23 }

# Pricing Rules
BogoRule.find_or_create_by!(sku: "GR1")
BulkPriceRule.find_or_create_by!(sku: "SR1", threshold: 3, new_price: 4.5)
PercentageBulkRule.find_or_create_by!(sku: "CF1", threshold: 3, factor: 2.0/3.0)

# Cart
Cart.first_or_create!
