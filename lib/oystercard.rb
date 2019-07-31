# frozen_string_literal: true

class Oystercard
  attr_reader :balance, :entry_station

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  def initialize
    @balance = 0
    @in_journey = false
    @entry_station = nil
  end

  def top_up(amount)
    raise "Cannot top_up: max limit is #{MAXIMUM_BALANCE}" if exceeds_limit?(amount)

    @balance += amount
  end

  def touch_in(entry_station)
    raise 'Cannot touch in: insufficient balance' unless sufficient_balance?
    @entry_station = entry_station
    @in_journey = true
  end

  def touch_out
    @in_journey = false
    @entry_station = nil
    deduct(MINIMUM_BALANCE)
  end

  private

  def exceeds_limit?(amount)
    @balance + amount > MAXIMUM_BALANCE
  end

  def in_journey?
    @in_journey
  end

  def sufficient_balance?
    @balance < MINIMUM_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end
end
