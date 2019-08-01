class Journey

  attr_reader :entry_station
  attr_accessor :exit_station
  PENALTY_FARE = 6

  #should only take one arg
  def initialize(entry_station, exit_station)
    @entry_station = entry_station
    @exit_station = exit_station
  end

  def fare
    if complete?
      return 1
    else
      return 6
    end
  end

  def complete?
  (entry_station && exit_station) ? true : false
  end
end
