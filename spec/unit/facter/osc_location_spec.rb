require 'spec_helper'
require 'facter/util/osc'

describe 'osc_location Fact' do
  context 'example nodes' do
    before :each do
      Facter.clear
      allow(Facter.fact(:nfsroot)).to receive(:value).and_return(true)
      allow(Facter).to receive(:value).with(:hostname).and_return('compute01')
      allow(Facter).to receive(:value).with(:cluster).and_return('example')
      allow(Facter::Util::Osc).to receive(:load_data).with('example').and_return(YAML.load(example_fixtures))
    end

    it "should return location hash" do
      expect(Facter.fact(:osc_location).value).to include('chassis' => 1)
      expect(Facter.fact(:osc_location).value).to include('position' => 'BACK_RIGHT')
      expect(Facter.fact(:osc_location).value).to include('rack' => 1)
      expect(Facter.fact(:osc_location).value).to include('sled' => 1)
      expect(Facter.fact(:osc_location).value).to include('u' => 2)
    end
  end
end
