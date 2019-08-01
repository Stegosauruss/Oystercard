# frozen_string_literal: true

require 'journey'

describe Journey do
  let(:station_double_one) { double(:station, zone: 1) }
  let(:station_double_two) { double(:station, zone: 2) }
  let(:station_double_three) { double(:station, zone: 3) }
  let(:penalty_fare) { Journey::PENALTY_FARE }

  describe '#fare' do
    it 'charges 1 between the same zone' do
      journey = described_class.new(station_double_one)
      journey.add_exit(station_double_one)
      expect(journey.fare).to eq 1
    end

    it 'charges PENALTY_FARE with no entry station' do
      journey = described_class.new
      journey.add_exit(station_double_one)
      expect(journey.fare).to eq penalty_fare
    end

    it 'charges PENALTY_FARE with no exit station' do
      journey = described_class.new(station_double_one)
      expect(journey.fare).to eq penalty_fare
    end

    it 'charges 2 for a journey crossing 2 zones' do
      journey = described_class.new(station_double_one)
      journey.add_exit(station_double_two)
      expect(journey.fare).to eq 2
    end

    it 'charges 3 for a journey crossing 3 zones' do
      journey = described_class.new(station_double_one)
      journey.add_exit(station_double_three)
      expect(journey.fare).to eq 3
    end
  end
end
