# frozen_string_literal: true

require_relative 'station'
require_relative 'journey'

class Oystercard
  attr_reader :balance, :journey
  attr_accessor :journey_log

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  def initialize(journey_class = Journey)
    @journey_log = []
    @entry_station = nil
    @balance = 0
    @journey_class = journey_class
  end

  def top_up(amount)
    raise "Cannot top_up: max limit is #{MAXIMUM_BALANCE}" if exceeds_limit?(amount)

    @balance += amount
  end

  def touch_in(current_station)
    raise 'Cannot touch in: insufficient balance' if insufficient_balance?
      
    complete_journey(nil) if in_journey?
    @entry_station = current_station

    #check journey_log.current_journey poss fare/add to log
    #create journey otherwise
  end

  def touch_out(exit_station)
    complete_journey(exit_station)
    #run finish
    #add to fare/log
  end

  private

  def exceeds_limit?(amount)
    @balance + amount > MAXIMUM_BALANCE
  end

  def in_journey?
    @entry_station != nil
  end

  def insufficient_balance?
    @balance < MINIMUM_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end

  def complete_journey(exit_station)
    journey = @journey_class.new(@entry_station, exit_station)
    @journey_log << journey
    deduct(journey.fare)
    @entry_station = nil
  end
end
