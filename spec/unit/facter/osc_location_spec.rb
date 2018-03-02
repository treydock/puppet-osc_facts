require 'spec_helper'
require 'facter/util/osc'

describe 'osc_location Fact' do
  context 'example nodes' do
    before :each do
      Facter.clear
      Facter.fact(:nfsroot).stubs(:value).returns(true)
      Facter.stubs(:value).with(:hostname).returns("compute01")
      Facter.stubs(:value).with(:cluster).returns("example")
      Facter::Util::Osc.stubs(:load_data).with("example").returns(YAML.load(example_fixtures))
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
