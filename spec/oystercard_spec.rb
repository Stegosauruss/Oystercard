require 'oystercard'

describe Oystercard do 
  let(:oystercard) {Oystercard.new}

  it 'has balance' do
    expect(oystercard.balance).not_to eq nil
  end

  describe "#top_up" do
    it "increases balance" do
      expect{oystercard.top_up(5)}.to change{oystercard.balance}.by(5)
    end

    it "cannot surpass maximum limit" do
      maxmimum_balance = Oystercard::MAXIMUM_BALANCE 
      oystercard.top_up(maxmimum_balance)
      expect { oystercard.top_up(1)}.to raise_error "Cannot top_up: max limit is #{maxmimum_balance}"
    end

  end

  describe "#deduct" do
    it "can be deducted" do 
      expect { oystercard.deduct(5) }.to change{oystercard.balance}.by(-5)
    end
  end
end
