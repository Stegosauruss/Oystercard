require 'station'

describe Station do
  let(:name_double) { :name }
  let(:zone_double) { :zone }
  let(:station) { described_class.new(name_double, zone_double) }

  it 'has a zone' do
    expect(station.zone).to eq :zone
  end

  it 'has a name' do
    expect(station.name).to eq :name
  end
end