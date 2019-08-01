require 'journey_log'
describe JourneyLog do
  let(:journey_double) { double(:journey, fare: true, exit_station: true) }
  let(:station_double) { double(:station) }
  let(:journey_class_double) { double(:journey_class, new: journey_double) }
  let(:journey_log) { described_class.new(journey_class_double) }

  describe '#start' do
    it 'starts a journey' do
      expect(journey_class_double).to receive(:new).with(station_double)
      journey_log.start(station_double)
    end
  end

  describe '#outstanding_charge' do
    it 'records a journey' do
      allow(journey_class_double).to receive(:new).with(station_double).and_return(journey_double)
      journey_log.start(station_double)
      journey_log.outstanding_charge
      expect(journey_log.journeys).to include journey_double
    end
  end

  describe 'finish' do
    it 'ends a journey' do
      allow(journey_class_double).to receive(:new).and_return(journey_double)
      expect(journey_double).to receive(:add_exit).with(station_double)
      journey_log.finish(station_double)
    end
  end
end



# it 'journey log is updated' do
#   card = Oystercard.new
#   card.top_up(10)
#   west_ham = Station.new("West Ham", 2)
#   london_bridge = Station.new("London Bridge", 1)

#   card.touch_in(west_ham)
#   card.touch_out(london_bridge)
#   expect().to eq west_ham
# end
