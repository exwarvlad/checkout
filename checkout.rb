require_relative 'item'

class Checkout
  def initialize(promotional_rules)
    # {discount_in_percent: {percent: 10, over_spend: 60}, discount_static: {amount: 2, discount: 8.5}}
    @discount_percent = promotional_rules[:discount_in_percent]
    @discount_static = promotional_rules[:discount_static]
    @card = []
  end

  def add(item)
    @card.push(item)
  end

  def total
    total_price = @card.map(&:price).sum
    total_price -= check_discount_static
    total_price -= total_price / 100 * @discount_percent[:percent] if discount_in_percent?(total_price)
    total_price
  end

  private

  def check_discount_static
    # check discount static in total sum
    # 3 items, discount_static_amount -- 1 item + discount_static_discount
    # 2 items, discount_static_amount -- discount_static_discount
    discount = 0
    @card.uniq.each do |item|
      items_price = @card.count(item) * item.price

      if @card.count(item) > @discount_static[:amount]
        discount += items_price - @card.count(item) / @discount_static[:amount] * item.price
        discount -= @discount_static[:discount] * (@card.count(item) - @discount_static[:amount])
      elsif @card.count(item) == @discount_static[:amount]
        discount += items_price
        discount -= @card.count(item) / @discount_static[:amount] * @discount_static[:discount]
      end
    end
    discount
  end

  def discount_in_percent?(total_price)
    total_price >= @discount_percent[:over_spend]
  end
end
