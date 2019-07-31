# frozen_string_literal: true

require_relative 'station'

class Oystercard
  attr_reader :balance, :journey, :entry_station
  attr_accessor :journey_log, :current_journey, :in_journey

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  def initialize
    @journey = Journey.new
    @in_journey = false
    @balance = 0
  end

  def top_up(amount)
    raise "Cannot top_up: max limit is #{MAXIMUM_BALANCE}" if exceeds_limit?(amount)

    @balance += amount
  end

  def touch_in(current_station)
    raise 'Cannot touch in: insufficient balance' if insufficient_balance?
    raise 'Cannot touch in: journey has begun' if in_journey?
    @in_journey = true
    log_touch_in(current_station)
  end

  def touch_out(current_station)
    deduct(MINIMUM_BALANCE)
    @in_journey = false
    log_touch_out(current_station)
    log_journey
  end

  private

  def exceeds_limit?(amount)
    @balance + amount > MAXIMUM_BALANCE
  end

  def in_journey?
    !@journey.current_journey[:entry_station].nil?
  end

  def insufficient_balance?
    @balance < MINIMUM_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end

  def log_journey
    @journey.journey_log << @journey.current_journey
    @current_journey = {
      :entry_station => nil,
      :exit_station => nil
    }
  end

  def log_touch_in(current_station)
    @journey.current_journey[:entry_station] = current_station.name
  end

  def log_touch_out(current_station)
    @journey.current_journey[:exit_station] = current_station.name
  end
end
