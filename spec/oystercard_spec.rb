require 'oystercard'

describe Oystercard do 
  let(:oystercard) {Oystercard.new}
  let(:minimum_balance) {Oystercard::MINIMUM_BALANCE}
  let(:maxmimum_balance) {Oystercard::MAXIMUM_BALANCE}

  it 'has balance' do
    expect(oystercard.balance).not_to eq nil
  end

  describe "#top_up" do
    it "increases balance" do
      expect{oystercard.top_up(5)}.to change{oystercard.balance}.by(5)
    end

    it "cannot surpass maximum limit" do
      oystercard.top_up(maxmimum_balance)
      expect { oystercard.top_up(1)}.to raise_error "Cannot top_up: max limit is #{maxmimum_balance}"
    end

  end

  describe "#deduct" do
    it "can be deducted" do 
      expect { oystercard.deduct(5) }.to change{oystercard.balance}.by(-5)
    end
  end

  describe "#touch_in" do
  
    context "when balance is below minimum charge" do 
      it "raises an error" do 
        expect{oystercard.touch_in}.to raise_error "Cannot touch in: insufficient balance"
      end
    end

    it "can touch in" do
      oystercard.top_up(minimum_balance)
      expect{oystercard.touch_in}.not_to raise_error
    end

    it "can touch out" do
      expect{oystercard.touch_out}.not_to raise_error
    end

    
  end
end
