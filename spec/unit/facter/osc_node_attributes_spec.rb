require 'spec_helper'
require 'facter/util/osc'

describe 'osc_node_attributes Fact' do
  context 'example' do
    before :each do
      Facter.clear
      Facter.fact(:nfsroot).stubs(:value).returns(true)
      Facter.stubs(:value).with(:cluster).returns("example")
      Facter::Util::Osc.stubs(:load_data).with("example").returns(YAML.load(example_fixtures))
    end

    it 'should be pfsdir for c6320 nodes' do
      Facter.stubs(:value).with(:hostname).returns("compute01")
      expect(Facter.fact(:osc_node_attributes).value).to eq(['pfsdir'])
    end

    it 'should be vis and pfsdir for vis nodes' do
      Facter.stubs(:value).with(:hostname).returns("compute02")
      expect(Facter.fact(:osc_node_attributes).value).to eq(['vis', 'pfsdir'])
    end

    it 'should be nil for login nodes' do
      Facter.stubs(:value).with(:hostname).returns("login01")
      expect(Facter.fact(:osc_node_attributes).value).to be_nil
    end

    it 'should be nil for RW nodes' do
      Facter.stubs(:value).with(:hostname).returns("rw01")
      expect(Facter.fact(:osc_node_attributes).value).to be_nil
    end
  end
end
