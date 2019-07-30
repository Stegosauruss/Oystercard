# frozen_string_literal: true

class Oystercard
  attr_reader :balance, :entry_station
  attr_accessor :journey_log, :current_journey

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  def initialize
    @balance = 0
    @current_journey = {
      :entry_station => nil, 
      :exit_station => nil
    }
    @journey_log = []
  end

  def top_up(amount)
    raise "Cannot top_up: max limit is #{MAXIMUM_BALANCE}" if exceeds_limit?(amount)

    @balance += amount
  end

  def touch_in(entry_station)
    raise 'Cannot touch in: insufficient balance' if insufficient_balance?
    raise 'Cannot touch in: journey has begun' if in_journey?

    log_touch_in(entry_station)
  end

  def touch_out(exit_station)
    deduct(MINIMUM_BALANCE)
    log_touch_out(exit_station)
    log_journey
  end

  private

  def exceeds_limit?(amount)
    @balance + amount > MAXIMUM_BALANCE
  end

  def in_journey?
    !@current_journey[:entry_station].nil?
  end

  def insufficient_balance?
    @balance < MINIMUM_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end

  def log_journey
    @journey_log << @current_journey
    wipe_journey
  end

  def log_touch_in(touch)
    @current_journey[:entry_station] = touch
  end

  def log_touch_out(touch)
    @current_journey[:exit_station] = touch
  end

  def wipe_journey
    @current_journey = {
      :entry_station => nil, 
      :exit_station => nil
    }
  end
end
