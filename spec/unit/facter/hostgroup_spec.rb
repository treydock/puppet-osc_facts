require 'spec_helper'
require 'facter/util/osc'
require 'facter/util/file_read'

describe 'hostgroup Fact' do
  before { Facter.clear }

  context 'compute node' do
    before :each do
      allow(Facter).to receive(:value).with(:cluster).and_return('example')
      allow(Facter).to receive(:value).with(:hostname).and_return('compute01')
      allow(Facter).to receive(:value).with(:nfsroot).and_return(true)
      allow(Facter::Util::Osc).to receive(:load_data).with('example').and_return(YAML.load(example_fixtures))
    end

    it "should return base/example/compute" do
      expect(Facter.fact(:hostgroup).value).to eq('base/example/compute')
    end
  end

  context 'login nodes' do
    before do
      allow(Facter).to receive(:value).with(:cluster).and_return('example')
      allow(Facter).to receive(:value).with(:hostname).and_return('login01')
      allow(Facter).to receive(:value).with(:nfsroot).and_return(true)
      allow(Facter::Util::Osc).to receive(:load_data).with('example').and_return(YAML.load(example_fixtures))
    end

    it "should return base/example/login" do
      expect(Facter.fact(:hostgroup).value).to eq('base/example/login')
    end
  end

  context 'non-nfsroot system' do
    before do
      allow(Facter).to receive(:value).with(:nfsroot).and_return(false)
    end

    it 'should return base' do
      allow(File).to receive(:exists?).with('/etc/facter/facts.d/facts.txt').and_return(true)
      allow(File).to receive(:read).with('/etc/facter/facts.d/facts.txt').and_return("hostgroup=base\nrandomfact=value")
      expect(Facter.fact(:hostgroup).value).to eq('base')
    end
  end
end
