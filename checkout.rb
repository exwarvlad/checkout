require_relative 'item'

class Checkout
  def initialize(promotional_rules)
    # {discount_percent: {percent: 10, over_spend: 60}, discount_static: {amount: 2, discount: 8.5}}
    @discount_percent = promotional_rules[:discount_percent]
    @discount_static = promotional_rules[:discount_static]
    @card = []
  end

  def add(item)
    @card.push(item)
  end

  def total
    total_price = @card.map(&:price).sum
    total_price -= check_discount_static
    total_price -= total_price / 100 * @discount_percent[:percent].to_f if total_price >= @discount_percent[:over_spend]
    total_price
  end

  private

  def check_discount_static
    amount = 0
    items = @card.select { |item| @card.count(item) >= @discount_static[:amount] }
    items.uniq.each { |item| amount += (item.price * @card.count(item) - @discount_static[:discount]) }
    amount
  end
end
