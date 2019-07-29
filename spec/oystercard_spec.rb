require 'oystercard'

describe Oystercard do 
  let(:oystercard) {Oystercard.new}

  it 'has balance' do
    expect(oystercard.balance).not_to eq nil
  end

end