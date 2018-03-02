require 'spec_helper'
require 'facter/util/osc'

describe 'cluster_host_location Fact' do
  context 'owens' do
    before :each do
      Facter.clear
      Facter.fact(:nfsroot).stubs(:value).returns(true)
      Facter.stubs(:value).with(:cluster).returns('example')
      Facter::Util::Osc.stubs(:load_data).with("example").returns(YAML.load(example_fixtures))
    end

    it 'should be hash for c6320 nodes' do
      Facter.stubs(:value).with(:hostname).returns('compute01')
      expect(Facter.fact(:cluster_host_location).value).to include(
        'chassis' => 1,
        'position' => 'BACK_RIGHT',
        'rack' => 1,
        'sled' => 1,
        'u' => 2
      )
    end
  end
end
