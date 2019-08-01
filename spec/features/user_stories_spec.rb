# frozen_string_literal: true

require 'oystercard'
describe 'User Stories' do
  let(:oystercard) { Oystercard.new }
  let(:minimum_balance) { Oystercard::MINIMUM_BALANCE }
  let(:maxmimum_balance) { Oystercard::MAXIMUM_BALANCE }
  let(:station) { Station.new("West Ham", 2) }

  # In order to use public transport
  # As a customer
  # I want money on my card
  it 'customers can have money on their oystercard' do
    expect(oystercard.balance).not_to eq nil
  end

  describe 'oystercard balances' do
    # In order to keep using public transport
    # As a customer
    # I want to add money to my card
    it 'can increase' do
      expect { oystercard.top_up(5) }.to change { oystercard.balance }.by(5)
    end

    # In order to protect my money from theft or loss
    # As a customer
    # I want a maximum limit (of 90 pounds) on my card
    context 'surpassing maximum limit do' do
      it 'cannot surpass maximum limit' do
        oystercard.top_up(maxmimum_balance)
        message = "Cannot top_up: max limit is #{maxmimum_balance}"
        expect { oystercard.top_up(1) }.to raise_error message
      end
    end
  end

  describe 'while travelling' do
    # In order to get through the barriers.
    # As a customer
    # I need to touch in and out.
    it 'touching in twice charges the penalty fare' do
      oystercard.top_up(10)
      oystercard.touch_in(station)
      oystercard.touch_in(station)
      expect(oystercard.balance).to eq 4
    end

    # In order to pay for my journey
    # As a customer
    # When my journey is complete, I need the correct amount deducted from my card
    it 'touching out deducts from the balance' do
      oystercard.top_up(minimum_balance)
      oystercard.touch_in(station)
      expect { oystercard.touch_out(station) }.to change(oystercard, :balance).by(-minimum_balance)
    end

    # In order to know how far I have travelled
    # As a customer
    # I want to know what zone a station is in

    pending 'zones have an effect'
  end


  # In order to pay for my journey
  # As a customer
  # I need to know where I've travelled from

  # In order to know where I have been
  # As a customer
  # I want to see all my previous trips

  it 'see previous trips' do
    oystercard.top_up(minimum_balance)
    oystercard.touch_in(station)
    oystercard.touch_out(station)
    expect(oystercard.past_journeys[0].entry_station).to eq station
  end


end
