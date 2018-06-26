require 'spec_helper'
require 'facter/util/osc'

describe 'osc_node_attributes Fact' do
  context 'example' do
    before :each do
      Facter.clear
      allow(Facter.fact(:nfsroot)).to receive(:value).and_return(true)
      allow(Facter).to receive(:value).with(:cluster).and_return('example')
      allow(Facter::Util::Osc).to receive(:load_data).with('example').and_return(YAML.load(example_fixtures))
    end

    it 'should be pfsdir for c6320 nodes' do
      allow(Facter).to receive(:value).with(:hostname).and_return('compute01')
      expect(Facter.fact(:osc_node_attributes).value).to eq(['pfsdir'])
    end

    it 'should be vis and pfsdir for vis nodes' do
      allow(Facter).to receive(:value).with(:hostname).and_return('compute02')
      expect(Facter.fact(:osc_node_attributes).value).to eq(['vis', 'pfsdir'])
    end

    it 'should be nil for login nodes' do
      allow(Facter).to receive(:value).with(:hostname).and_return('login01')
      expect(Facter.fact(:osc_node_attributes).value).to be_nil
    end

    it 'should be nil for RW nodes' do
      allow(Facter).to receive(:value).with(:hostname).and_return('rw01')
      expect(Facter.fact(:osc_node_attributes).value).to be_nil
    end
  end
end
