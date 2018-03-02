require 'spec_helper'
require 'facter/util/file_read'
require 'facter/ipoib_address' # Needed to load file with name that does not match fact

describe 'ipoib_address_ib0 Fact' do
  before { Facter.clear }

  context 'compute node' do
    before :each do
      Facter.fact(:nfsroot).stubs(:value).returns(true)
      Facter.stubs(:value).with(:cluster).returns("example")
      Facter.stubs(:value).with(:hostname).returns('compute01')
      Facter::Util::Osc.stubs(:load_data).with("example").returns(YAML.load(example_fixtures))
      Facter.collection.internal_loader.load(:ipoib_address) # Needed to load file with name that does not match fact
    end

    it "should return ib0 IP address" do
      expect(Facter.fact(:ipoib_address_ib0).value).to eq('10.0.0.1')
    end
  end

  context 'login nodes' do
    before do
      Facter.stubs(:value).with(:cluster).returns("example")
      Facter.stubs(:value).with(:hostname).returns('login01')
      Facter.fact(:nfsroot).stubs(:value).returns(true)
      Facter::Util::Osc.stubs(:load_data).with("example").returns(YAML.load(example_fixtures))
      Facter.collection.internal_loader.load(:ipoib_address) # Needed to load file with name that does not match fact
    end

    it "should return ib0 IP address" do
      expect(Facter.fact(:ipoib_address_ib0).value).to eq('10.0.0.3')
    end
  end
end
