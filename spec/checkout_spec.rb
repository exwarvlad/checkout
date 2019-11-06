require 'rspec'
require_relative '../checkout'

describe 'checkout' do
  let!(:rules) { {discount_percent: {percent: 10, over_spend: 60}, discount_static: {amount: 2, discount: 8.5}} }
  let!(:item1) { Item.new(code: 001, name: 'bum-shaka-laka', price: 42) }
  let!(:item2) { Item.new(code: 002, name: 'banana', price: 61) }

  it '.total' do
    checkout = Checkout.new(rules)
    checkout.add(item1)
    checkout.add(item1)
    checkout.add(item2)
    price = rules[:discount_static][:discount] + item2.price
    discount = (rules[:discount_static][:discount] + item2.price) / 100 * rules[:discount_percent][:percent]

    expect(checkout.total).to eq(price - discount)
  end
end
