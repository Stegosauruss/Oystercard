class Oystercard

  attr_reader :balance

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(amount)
    raise "Cannot top_up: max limit is #{MAXIMUM_BALANCE}" if exceeds_limit?(amount)
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def touch_in
    raise "Cannot touch in: insufficient balance" unless sufficient_balance?
    @in_journey = true
  end

  def touch_out
    @in_journey = false
  end

  private

  def exceeds_limit?(amount)
    @balance + amount > MAXIMUM_BALANCE
  end

  def in_journey?
    @in_journey
  end

  def sufficient_balance?
    @balance >= MINIMUM_BALANCE
  end
 
end