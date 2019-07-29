require 'oystercard'
describe 'User Stories' do
  let(:oystercard) { Oystercard.new }

  # In order to use public transport
  # As a customer
  # I want money on my card
  it "so customers can travel, they can have money on their oystercard" do
    expect(oystercard.balance).not_to eq nil
  end
end



