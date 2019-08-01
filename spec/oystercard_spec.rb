# frozen_string_literal: true

require 'oystercard'

describe Oystercard do
  let(:journey_double) { double(:journey, fare: 1) }
  let(:journey_class_double) { double(:journey_class, new: journey_double) }
  let(:oystercard) { Oystercard.new(journey_class_double) }
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

    context 'when already touched in' do
      before do
        allow(journey_double).to receive(:fare).and_return(6)
      end

      it "charges the penalty fare" do
        station_double = double(station_double, name: "West Ham")
        oystercard.top_up(10)
        oystercard.touch_in(station_double)
        oystercard.touch_in(station_double)
        expect(oystercard.balance).to eq 4
      end
    end
  end

  describe '#touch_out' do
    it "doesn't raise an error" do
      oystercard.top_up(minimum_balance)
      exit_station_double = double(station_double, name: "London Bridge")
      expect { oystercard.touch_out(exit_station_double) }.not_to raise_error
    end

    it 'deducts minimum fare from balance' do
      exit_station_double = double(station_double, name: "London Bridge")
      expect { oystercard.touch_out(exit_station_double) }.to change(oystercard, :balance).by(-minimum_balance)
    end

    context 'when not touched in' do
      before do
        allow(journey_double).to receive(:fare).and_return(6)
      end

      it 'charges the penalty fare' do
        station_double = double(station_double, name: "West Ham")
        oystercard.top_up(10)
        oystercard.touch_out(station_double)
        expect(oystercard.balance).to eq 4
      end
    end

  end

  describe '#journey_log' do
    it 'starts journey with an empty log' do
      expect(oystercard.journey_log).to be_empty
    end

  end
end
