# frozen_string_literal: true

require 'oystercard'
describe 'User Stories' do
  let(:oystercard) { Oystercard.new }
  let(:minimum_balance) { Oystercard::MINIMUM_BALANCE }
  let(:maxmimum_balance) { Oystercard::MAXIMUM_BALANCE }
  let(:station_double) { :station }
  let(:exit_station_double) { :station }

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
    it 'touching in starts a journey' do
      oystercard.top_up(minimum_balance)
      expect { oystercard.touch_in(station_double) }.to change(oystercard, :in_journey?).to(true)
    end

    # In order to pay for my journey
    # As a customer
    # When my journey is complete, I need the correct amount deducted from my card
    it 'touching out deducts from the balance' do
      oystercard.top_up(minimum_balance)
      oystercard.touch_in(station_double)
      expect { oystercard.touch_out(exit_station_double) }.to change(oystercard, :balance).by(-minimum_balance)
    end

    # In order to know how far I have travelled
    # As a customer
    # I want to know what zone a station is in

  end

  describe 'after journeys' do
    let(:journey) { {entry_station: station_double, exit_station: exit_station_double} }
    # In order to pay for my journey
    # As a customer
    # I need to know where I've travelled from

    # In order to know where I have been
    # As a customer
    # I want to see all my previous trips
  
    it 'past trips are logged' do
      oystercard.top_up(minimum_balance)
      oystercard.touch_in(station_double)
      oystercard.touch_out(exit_station_double)
      expect(oystercard.journey_log).to include journey
    end
  end

  describe 'a full journey' do 
    xit 'logs a journey with zone information' do
      card = Oystercard.new
      card.top_up(10)
      west_ham = Station.new("West Ham", 2)
      london_bridge = Station.new("London Bridge", 1)

      card.touch_in(west_ham)
      card.touch_out(london_bridge)
      expect(card.journey_log).to eq [{ :entry_station => "West Ham" , :exit_station => "London Bridge" }]

    end
  end


end
