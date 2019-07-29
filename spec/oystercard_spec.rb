require 'oystercard'

describe Oystercard do 
  let(:oystercard) {Oystercard.new}

  it 'has balance' do
    expect(oystercard.balance).not_to eq nil
  end

  it "tops up" do
    expect{oystercard.top_up(5)}.to change{oystercard.balance}.by(5)
  end

end