# frozen_string_literal: true

class Journey
  attr_reader :entry_station
  PENALTY_FARE = 6

  # should only take one arg
  def initialize(entry_station = nil)
    @entry_station = entry_station
    @exit_station = nil
  end

  def fare
    if complete?
      calculate_fare
    else
      PENALTY_FARE
    end
  end

  def add_exit(station)
    @exit_station = station
  end

  private

  def complete?
    @entry_station && @exit_station ? true : false
  end

  def calculate_fare
    1 + (@entry_station.zone - @exit_station.zone).abs
  end
end
