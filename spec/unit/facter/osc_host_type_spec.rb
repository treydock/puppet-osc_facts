require 'spec_helper'
require 'facter/util/osc'

describe 'osc_host_type Fact' do
  context 'example' do
    before :each do
      Facter.clear
      Facter.fact(:nfsroot).stubs(:value).returns(true)
      Facter.stubs(:value).with(:cluster).returns("example")
      Facter::Util::Osc.stubs(:load_data).with("example").returns(YAML.load(example_fixtures))
    end

    it "c6320 should return compute" do
      Facter.stubs(:value).with(:hostname).returns("compute01")
      expect(Facter.fact(:osc_host_type).value).to eq('compute')
    end

    it "login nodes should return login" do
      Facter.stubs(:value).with(:hostname).returns("login01")
      expect(Facter.fact(:osc_host_type).value).to eq('login')
    end

    it "RW hosts should return rw" do
      Facter.stubs(:value).with(:hostname).returns("rw01")
      expect(Facter.fact(:osc_host_type).value).to eq('rw')
    end
  end
end
