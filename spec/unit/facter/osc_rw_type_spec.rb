require 'spec_helper'
require 'facter/util/file_read'
require 'facter/util/osc'

describe 'osc_rw_type Fact' do
  context 'example' do
    before :each do
      Facter.clear
      Facter.fact(:nfsroot).stubs(:value).returns(true)
      Facter.stubs(:value).with(:osc_host_type).returns('rw')
      Facter.stubs(:value).with(:cluster).returns("example")
      Facter::Util::Osc.stubs(:load_data).with("example").returns(YAML.load(example_fixtures))
    end

    it "should not return none" do
      Facter.stubs(:value).with(:hostname).returns("rw01")
      expect(Facter.fact(:osc_rw_type).value).not_to eq('none')
    end

    it "should return login" do
      Facter.stubs(:value).with(:hostname).returns("login01")
      expect(Facter.fact(:osc_rw_type).value).to eq('none')
    end
  end
end
