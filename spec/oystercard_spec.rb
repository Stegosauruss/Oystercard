# frozen_string_literal: true

require 'oystercard'

describe Oystercard do
  let(:oystercard) { Oystercard.new }
  let(:minimum_balance) { Oystercard::MINIMUM_BALANCE }
  let(:maxmimum_balance) { Oystercard::MAXIMUM_BALANCE }
  let(:station_double) { :station }
  let(:exit_station_double) { :station }

  it 'has balance' do
    expect(oystercard.balance).not_to eq nil
  end
  describe '#top_up' do
    it 'increases balance' do
      expect { oystercard.top_up(5) }.to change { oystercard.balance }.by(5)
    end
    it 'cannot surpass maximum limit' do
      oystercard.top_up(maxmimum_balance)
      expect { oystercard.top_up(1) }.to raise_error "Cannot top_up: max limit is #{maxmimum_balance}"
    end
  end

  describe '#touch_in' do
    context 'when balance is below minimum charge' do
      it 'raises an error' do
        station_double = double(station_double, name: "West Ham")
        message = 'Cannot touch in: insufficient balance'
        expect { oystercard.touch_in(station_double) }.to raise_error message
      end
    end

    context 'touching in twice' do
      it "raises an error" do
        station_double = double(station_double, name: "West Ham")
        oystercard.top_up(minimum_balance)
        oystercard.touch_in(station_double)
        expect { oystercard.touch_in(station_double) }.to raise_error 'Cannot touch in: journey has begun'
      end
    end

    it "stores entry station" do
      oystercard.top_up(1)
      station = Station.new("Stratford", 1)
      oystercard.touch_in(station)
      expect(oystercard.journey.current_journey[:entry_station]).to eq (station.name)
    end
  end

  describe '#touch_out' do
    it 'changes in_journey to false' do
      station_double = double(station_double, name: "West Ham")
      exit_station_double = double(station_double, name: "London Bridge")
      oystercard.top_up(minimum_balance)
      oystercard.touch_in(station_double)
      expect { oystercard.touch_out(exit_station_double) }.to change{oystercard.in_journey}.to(false)
    end

    it "doesn't raise an error" do
      oystercard.top_up(minimum_balance)
      exit_station_double = double(station_double, name: "London Bridge")
      expect { oystercard.touch_out(exit_station_double) }.not_to raise_error
    end

    it 'deducts minimum fare from balance' do
      exit_station_double = double(station_double, name: "London Bridge")
      expect { oystercard.touch_out(exit_station_double) }.to change(oystercard, :balance).by(-minimum_balance)
    end
  end

  describe '#journey_log' do
    it 'starts journey with an empty log' do
      expect(oystercard.journey.journey_log).to be_empty
    end

  end
end
