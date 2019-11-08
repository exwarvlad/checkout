require 'rspec'
require_relative '../checkout'

describe 'Checkout .total' do
  let!(:rules) { {discount_in_percent: {percent: 10, over_spend: 42}, discount_static: {amount: 2, discount: 8.5}} }
  let!(:item1) { Item.new(code: 001, name: 'bum-shaka-laka', price: 42) }
  let!(:item2) { Item.new(code: 002, name: 'banana', price: 10) }

  it 'discount_in_percent' do
    co = Checkout.new(rules)
    co.add(item1)

    expect(co.total).to eq(item1.price.to_f - item1.price / 100 * rules[:discount_in_percent][:percent])
  end

  it 'discount_static' do
    co = Checkout.new(rules)
    co.add(item2)
    co.add(item2)
    co.add(item2)

    co2 = Checkout.new(rules)
    co2.add(item2)
    co2.add(item2)

    # expect(co.total).to eq(rules[:discount_static][:discount] + item2.price)
    expect(co2.total).to eq(rules[:discount_static][:discount])
  end

  it 'discount_in_percent and discount_static' do
    co = Checkout.new(rules)
    co.add(item1)
    co.add(item2)
    co.add(item2)
    co.add(item2)
    with_statick_discount = rules[:discount_static][:discount] + item2.price + item1.price
    total_sum = with_statick_discount - with_statick_discount / 100 * rules[:discount_in_percent][:percent]

    expect(co.total).to eq total_sum
  end
end
