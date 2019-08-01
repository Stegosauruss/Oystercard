require 'journey'

describe Journey do
  let(:station_double) { double(:station) }
  let(:penalty_fare) { Journey::PENALTY_FARE }

  describe '#fare' do
    it 'charges 1 with a full journey' do
      journey = described_class.new(station_double, station_double)
      expect(journey.fare).to eq 1
    end

    it 'charges 6 with no entry station' do
      journey = described_class.new(nil, station_double)
      expect(journey.fare).to eq penalty_fare
    end

    it 'charges 6 with no exit station' do
      journey = described_class.new(station_double, nil)
      expect(journey.fare).to eq penalty_fare
    end
  end
end
