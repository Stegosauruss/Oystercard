class Journey

  attr_reader :entry_station
  PENALTY_FARE = 6

  #should only take one arg
  def initialize(entry_station = nil)
    @entry_station = entry_station
    @exit_station = nil
  end

  def fare
    if complete?
      return 1
    else
      return PENALTY_FARE
    end
  end

  def add_exit(station)
    @exit_station = station
  end

  def complete?
  (@entry_station && @exit_station) ? true : false
  end
end
