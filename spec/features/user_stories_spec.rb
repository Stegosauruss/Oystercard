require 'oystercard'
describe 'User Stories' do
  let(:oystercard) { Oystercard.new }

  # In order to use public transport
  # As a customer
  # I want money on my card
  it "so customers can travel, they can have money on their oystercard" do
    expect(oystercard.balance).not_to eq nil
  end

  # In order to keep using public transport
  # As a customer
  # I want to add money to my card
  it "so that i can travel, I want to add money to my balance" do 
    expect{oystercard.top_up(5)}.to change{oystercard.balance}.by(5)
  end
end



