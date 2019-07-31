# frozen_string_literal: true

require 'oystercard'

describe 'User Stories' do
  let(:oystercard) { Oystercard.new }
  let(:minimum_balance) { Oystercard::MINIMUM_BALANCE }
  let(:maxmimum_balance) { Oystercard::MAXIMUM_BALANCE }

  # In order to use public transport
  # As a customer
  # I want money on my card
  it 'so customers can travel, they can have money on their oystercard' do
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
    # I want a maximum limit (of 90) on my card
    it 'cannot surpass maximum limit' do
      oystercard.top_up(maxmimum_balance)
      message = "Cannot top_up: max limit is #{maxmimum_balance}"
      expect { oystercard.top_up(1) }.to raise_error message
    end
  end

  describe 'while travelling' do
    # In order to get through the barriers.
    # As a customer
    # I need to touch in and out.
    it 'touching in starts a journey' do
      oystercard.top_up(minimum_balance)
      expect { oystercard.touch_in }.to change(oystercard, :in_journey?).to true
    end

    # In order to pay for my journey
    # As a customer
    # When my journey is complete, I need the correct amount deducted from my card
    it 'touching out deducts from the balance' do
      oystercard.top_up(minimum_balance)
      oystercard.touch_in
      expect { oystercard.touch_out }.to change(oystercard, :balance).by(-minimum_balance)
    end
  end
end
