class CreatePricingRules < ActiveRecord::Migration[8.0]
  def change
    create_table :pricing_rules do |t|
      t.string :type
      t.string :sku
      t.integer :threshold
      t.decimal :new_price
      t.decimal :factor

      t.timestamps
    end
  end
end
