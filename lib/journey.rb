class Journey

  attr_accessor :current_journey, :journey_log

  def initialize
    @current_journey = {
      :entry_station => nil,
      :exit_station => nil
    }
    @journey_log = []
  end
end
