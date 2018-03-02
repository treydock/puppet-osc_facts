require 'spec_helper'
require 'facter/util/file_read'

describe 'osc_partition_schema Fact' do
  context 'example' do
    before :each do
      Facter.clear
      Facter.fact(:nfsroot).stubs(:value).returns(true)
      Facter.stubs(:value).with(:cluster).returns("example")
      Facter::Util::Osc.stubs(:load_data).with("example").returns(YAML.load(example_fixtures))
    end

    it "should return default" do
      Facter.stubs(:value).with(:hostname).returns("compute01")
      expect(Facter.fact(:osc_partition_schema).value).to eq('default')
    end

    it "should return login" do
      Facter.stubs(:value).with(:hostname).returns("login01")
      expect(Facter.fact(:osc_partition_schema).value).to eq('default')
    end

    it "should return rw" do
      Facter.stubs(:value).with(:hostname).returns("rw01")
      expect(Facter.fact(:osc_partition_schema).value).to eq('rw')
    end
  end
end
