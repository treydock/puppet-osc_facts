require 'spec_helper'
require 'facter/util/osc'

describe 'osc_rw_type Fact' do
  context 'example' do
    before :each do
      Facter.clear
      allow(Facter.fact(:nfsroot)).to receive(:value).and_return(true)
      allow(Facter.fact(:osc_host_type)).to receive(:value).and_return('rw')
      allow(Facter).to receive(:value).with(:cluster).and_return('example')
      allow(Facter::Util::Osc).to receive(:load_data).with("example").and_return(YAML.load(example_fixtures))
    end

    it "should not return none" do
      allow(Facter).to receive(:value).with(:hostname).and_return('rw01')
      expect(Facter.fact(:osc_rw_type).value).not_to eq('none')
    end

    it "should return login" do
      allow(Facter).to receive(:value).with(:hostname).and_return('login01')
      expect(Facter.fact(:osc_rw_type).value).to eq('none')
    end
  end
end
