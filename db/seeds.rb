# Products
Product.create!(code: "GR1", name: "Green Tea", price: 3.11)
Product.create!(code: "SR1", name: "Strawberries", price: 5.00)
Product.create!(code: "CF1", name: "Coffee", price: 11.23)

# Pricing Rules
BogoRule.create!(sku: "GR1")
BulkPriceRule.create!(sku: "SR1", threshold: 3, new_price: 4.5)
PercentageBulkRule.create!(sku: "CF1", threshold: 3, factor: 2.0/3.0)

# Cart
Cart.create!
