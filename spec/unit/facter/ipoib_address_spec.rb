require 'spec_helper'
require 'facter/util/file_read'
require 'facter/ipoib_address' # Needed to load file with name that does not match fact

describe 'ipoib_address_ib0 Fact' do
  before { Facter.clear }

  context 'compute node' do
    before :each do
      allow(Facter.fact(:nfsroot)).to receive(:value).and_return(true)
      allow(Facter).to receive(:value).with(:cluster).and_return('example')
      allow(Facter).to receive(:value).with(:hostname).and_return('compute01')
      allow(Facter::Util::Osc).to receive(:load_data).with('example').and_return(YAML.load(example_fixtures))
      Facter.collection.internal_loader.load(:ipoib_address) # Needed to load file with name that does not match fact
    end

    it "should return ib0 IP address" do
      expect(Facter.fact(:ipoib_address_ib0).value).to eq('10.0.0.1')
    end
  end

  context 'login nodes' do
    before do
      allow(Facter).to receive(:value).with(:cluster).and_return('example')
      allow(Facter).to receive(:value).with(:hostname).and_return('login01')
      allow(Facter.fact(:nfsroot)).to receive(:value).and_return(true)
      allow(Facter::Util::Osc).to receive(:load_data).with('example').and_return(YAML.load(example_fixtures))
      Facter.collection.internal_loader.load(:ipoib_address) # Needed to load file with name that does not match fact
    end

    it "should return ib0 IP address" do
      expect(Facter.fact(:ipoib_address_ib0).value).to eq('10.0.0.3')
    end
  end
end
