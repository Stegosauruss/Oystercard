# frozen_string_literal: true

require_relative 'station'
require_relative 'journey_log'

class Oystercard
  attr_reader :balance, :journey

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  def initialize(journey_log = JourneyLog.new)
    @journey_log = journey_log
    @entry_station = nil
    @balance = 0
  end

  def top_up(amount)
    raise "Cannot top_up: max limit is #{MAXIMUM_BALANCE}" if exceeds_limit?(amount)

    @balance += amount
  end

  def touch_in(entry_station)
    raise 'Cannot touch in: insufficient balance' if insufficient_balance?

    if @journey_log.current_journey == nil
      @journey_log.start(entry_station)
    else  
      @journey_log.finish(nil)
      deduct(@journey_log.outstanding_charge)
    end
    
  end

  def touch_out(exit_station)

    @journey_log.finish(exit_station)
    deduct(@journey_log.outstanding_charge)
  end

  def past_journeys
    @journey_log.journeys
  end

  private

  def exceeds_limit?(amount)
    @balance + amount > MAXIMUM_BALANCE
  end

  def insufficient_balance?
    @balance < MINIMUM_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end

end
