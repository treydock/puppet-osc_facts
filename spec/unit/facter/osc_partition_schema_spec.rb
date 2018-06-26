require 'spec_helper'
require 'facter/util/osc'

describe 'osc_partition_schema Fact' do
  context 'example' do
    before :each do
      Facter.clear
      allow(Facter.fact(:nfsroot)).to receive(:value).and_return(true)
      allow(Facter).to receive(:value).with(:cluster).and_return('example')
      allow(Facter::Util::Osc).to receive(:load_data).with('example').and_return(YAML.load(example_fixtures))
    end

    it "should return default" do
      allow(Facter).to receive(:value).with(:hostname).and_return('compute01')
      expect(Facter.fact(:osc_partition_schema).value).to eq('default')
    end

    it "should return login" do
      allow(Facter).to receive(:value).with(:hostname).and_return('login01')
      expect(Facter.fact(:osc_partition_schema).value).to eq('default')
    end

    it "should return rw" do
      allow(Facter).to receive(:value).with(:hostname).and_return('rw01')
      expect(Facter.fact(:osc_partition_schema).value).to eq('rw')
    end
  end
end
