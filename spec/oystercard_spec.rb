# frozen_string_literal: true

require 'oystercard'

describe Oystercard do
  let(:journey_log_double) { double(:journey, finish: true, outstanding_charge: 1) }
  let(:oystercard) { Oystercard.new(journey_log_double) }
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
        allow(journey_log_double).to receive(:outstanding_charge).and_return(6)
      end

      it "charges the penalty fare" do
        station_double = double(station_double, name: "West Ham")
        oystercard.top_up(10)
        allow(journey_log_double).to receive(:current_journey).and_return(true)
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
        allow(journey_log_double).to receive(:outstanding_charge).and_return(6)
      end

      it 'charges the penalty fare' do
        station_double = double(station_double, name: "West Ham")
        oystercard.top_up(10)
        oystercard.touch_out(station_double)
        expect(oystercard.balance).to eq 4
      end
    end

  end
end
