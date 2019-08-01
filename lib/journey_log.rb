require_relative 'journey'
class JourneyLog
  attr_reader :journeys, :current_journey
  def initialize(journey_class = Journey)
    @journey_class = journey_class
    @journeys = []
    @current_journey = nil
  end

  def start(entry_station)
    @current_journey = @journey_class.new(entry_station)
  end

  def finish(exit_station)
    end_journey
    @current_journey.add_exit(exit_station)
  end

  def outstanding_charge
    charge = @current_journey.fare
    add_to_log
    charge
  end

  private

  def end_journey
    if @current_journey == nil
      @current_journey = @journey_class.new
    else
      @current_journey
    end
  end

  def add_to_log
    @journeys << @current_journey
    @current_journey = nil
  end
end