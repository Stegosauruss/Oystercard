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

  describe "#touch_in" do
  
    context "when balance is below minimum charge" do 
      it "raises an error" do 
        expect{oystercard.touch_in}.to raise_error "Cannot touch in: insufficient balance"
      end
    end

    it "doesn't raise an error" do
      oystercard.top_up(minimum_balance)
      expect{oystercard.touch_in}.not_to raise_error
    end
  end

  describe "#touch_out" do
    it "changes in_journey to false" do
      oystercard.top_up(minimum_balance)
      oystercard.touch_in
      expect{ oystercard.touch_out }.to change(oystercard, :in_journey?).to(false)
    end

    it "doesn't raise an error" do
      expect{oystercard.touch_out}.not_to raise_error
    end

    it "deducts minimum fare from balance" do
      expect{oystercard.touch_out}.to change(oystercard, :balance).by(-(minimum_balance))
    end
  end
end
