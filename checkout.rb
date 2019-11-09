require_relative 'lib/item'

class Checkout
  def initialize(promotional_rules)
    # {discount_in_percent: {percent: 10, over_spend: 60}, discount_static: {amount: 2, discount: 8.5}}
    @discount_percent = promotional_rules[:discount_in_percent]
    @discount_static = promotional_rules[:discount_static]
    @card = []
    @discount = 0
  end

  def add(item)
    @card.push(item)
    check_discount_static(@card.count(item), item)
  end

  def total
    total_price = @card.map(&:price).sum - @discount
    total_price -= total_price / 100 * @discount_percent[:percent] if discount_in_percent?(total_price)
    total_price
  end

  private

  def check_discount_static(items_counter, item)
    if items_counter >= @discount_static[:amount]
      new_price = (items_counter / @discount_static[:amount]) * @discount_static[:discount]
      old_price = (items_counter - (items_counter - @discount_static[:amount])) * item.price
      @discount = old_price - new_price
    end
  end

  def discount_in_percent?(total_price)
    total_price >= @discount_percent[:over_spend]
  end
end
