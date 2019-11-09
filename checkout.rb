require_relative 'lib/item'

class Checkout
  def initialize(promotional_rules)
    # {drop_of_percent: {amount: 10, over_spend: 60}, drop_of_cash: {amount: 2, price: 8.5}}
    @drop_of_percent = promotional_rules[:drop_of_percent]
    @drop_of_cash = promotional_rules[:drop_of_cash]
    @card = []
    @discount_of_cash = 0
  end

  def add(item)
    check_drop_of_cash(@card.count(item) + 1, item.price)
    @card.push(item)
    true
  end

  def total
    total_price = @card.map(&:price).sum - @discount_of_cash
    total_price -= total_price / 100 * @drop_of_percent[:amount] if discount_of_percent?(total_price)
    total_price
  end

  private

  def check_drop_of_cash(items_counter, item_price)
    if items_counter >= @drop_of_cash[:amount]
      new_price = (items_counter / @drop_of_cash[:amount]) * @drop_of_cash[:price]
      old_price = (items_counter - (items_counter - @drop_of_cash[:amount])) * item_price
      @discount_of_cash = old_price - new_price
    end
  end

  def discount_of_percent?(total_price)
    total_price >= @drop_of_percent[:over_spend]
  end
end
