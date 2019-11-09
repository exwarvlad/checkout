require 'rspec'
require_relative '../checkout'

describe 'Checkout .total' do
  let!(:rules) { {drop_of_percent: {amount: 10, over_spend: 42}, drop_of_cash: {amount: 2, price: 8.5}} }
  let!(:item1) { Item.new(code: 001, name: 'bum-shaka-laka', price: 42) }
  let!(:item2) { Item.new(code: 002, name: 'banana', price: 10) }

  it 'drop_of_percent' do
    co = Checkout.new(rules)
    co.add(item1)

    expect(co.total).to eq(item1.price - item1.price / 100 * rules[:drop_of_percent][:amount])
  end

  it 'drop_of_cash' do
    co = Checkout.new(rules)
    co.add(item2)
    co.add(item2)
    co.add(item2)

    co2 = Checkout.new(rules)
    counter = 6
    counter.times { co2.add(item2) }

    expect(co.total).to eq(rules[:drop_of_cash][:price] + item2.price)
    expect(co2.total).to eq(rules[:drop_of_cash][:price] * (counter / rules[:drop_of_cash][:amount]))
  end

  it 'drop_of_percent and drop_of_cash' do
    co = Checkout.new(rules)
    co.add(item1)
    co.add(item2)
    co.add(item2)
    co.add(item2)
    with_statick_discount = rules[:drop_of_cash][:price] + item2.price + item1.price
    total_sum = with_statick_discount - with_statick_discount / 100 * rules[:drop_of_percent][:amount]

    expect(co.total).to eq total_sum
  end
end
