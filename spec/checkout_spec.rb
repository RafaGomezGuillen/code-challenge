require 'spec_helper'

RSpec.describe 'Cash register' do
  let(:rules) do
    [
      BogoRule.new('GR1'),
      BulkPriceRule.new('SR1', threshold: 3, new_price: 4.5),
      PercentageBulkRule.new('CF1', threshold: 3, factor: (2.0 / 3.0))
    ]
  end

  it 'charges GR1,GR1 => 3.11€' do
    co = Checkout.new(pricing_rules: rules)
    co.scan('GR1')
    co.scan('GR1')
    expect(co.format_total).to eq('3.11€')
  end

  it 'charges SR1,SR1,GR1,SR1 => 16.61€' do
    co = Checkout.new(pricing_rules: rules)
    %w[SR1 SR1 GR1 SR1].each { |s| co.scan(s) }
    expect(co.format_total).to eq('16.61€')
  end

  it 'charges GR1,CF1,SR1,CF1,CF1 => 30.57€' do
    co = Checkout.new(pricing_rules: rules)
    %w[GR1 CF1 SR1 CF1 CF1].each { |s| co.scan(s) }
    expect(co.format_total).to eq('30.57€')
  end
end
