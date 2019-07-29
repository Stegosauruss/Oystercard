require 'oystercard'
describe 'User Stories' do
  let(:oystercard) { Oystercard.new }

  # In order to use public transport
  # As a customer
  # I want money on my card
  it "so customers can travel, they can have money on their oystercard" do
    expect(oystercard.balance).not_to eq nil
  end

  describe "oystercard balances" do
    # In order to keep using public transport
    # As a customer
    # I want to add money to my card
    it "can increase" do 
      expect { oystercard.top_up(5) }.to change{oystercard.balance}.by(5)
    end

    # In order to protect my money from theft or loss
    # As a customer
    # I want a maximum limit (of £90) on my card
    it "cannot surpass maximum limit" do
      maxmimum_balance = Oystercard::MAXIMUM_BALANCE 
      oystercard.top_up(maxmimum_balance)
      expect { oystercard.top_up(1)}.to raise_error "Cannot top_up: max limit is #{maxmimum_balance}"
    end

    # In order to pay for my journey
    # As a customer
    # I need my fare deducted from my card
    it "can be deducted" do 
      expect { oystercard.deduct(5) }.to change{oystercard.balance}.by(-5)
    end
  end
end
