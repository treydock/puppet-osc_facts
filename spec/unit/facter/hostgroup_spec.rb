require 'spec_helper'
require 'facter/util/osc'
require 'facter/util/file_read'

describe 'hostgroup Fact' do
  before { Facter.clear }

  context 'compute node' do
    before :each do
      Facter.stubs(:value).with(:cluster).returns("example")
      Facter.stubs(:value).with(:hostname).returns('compute01')
      Facter.stubs(:value).with(:nfsroot).returns(true)
      Facter::Util::Osc.stubs(:load_data).with("example").returns(YAML.load(example_fixtures))
    end

    it "should return base/example/compute" do
      expect(Facter.fact(:hostgroup).value).to eq('base/example/compute')
    end
  end

  context 'login nodes' do
    before do
      Facter.stubs(:value).with(:cluster).returns("example")
      Facter.stubs(:value).with(:hostname).returns('login01')
      Facter.stubs(:value).with(:nfsroot).returns(true)
      Facter::Util::Osc.stubs(:load_data).with("example").returns(YAML.load(example_fixtures))
    end

    it "should return base/example/login" do
      expect(Facter.fact(:hostgroup).value).to eq('base/example/login')
    end
  end

  context 'non-nfsroot system' do
    before do
      Facter.stubs(:value).with(:nfsroot).returns(false)
    end

    it 'should return base' do
      File.stubs(:exists?).with('/etc/facter/facts.d/facts.txt').returns(true)
      File.stubs(:read).with('/etc/facter/facts.d/facts.txt').returns("hostgroup=base\nrandomfact=value")
      expect(Facter.fact(:hostgroup).value).to eq('base')
    end
  end
end
