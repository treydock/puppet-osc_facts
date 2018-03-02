require 'spec_helper'

describe 'hostgroup_name fact' do
  before { Facter.clear }

  it 'should return compute' do
    Facter.stubs(:value).with(:hostgroup).returns('base/example/compute')
    expect(Facter.fact(:hostgroup_name).value).to eq('compute')
  end

  it 'should return batch_server' do
    Facter.stubs(:value).with(:hostgroup).returns('base/example/batch_server')
    expect(Facter.fact(:hostgroup_name).value).to eq('batch_server')
  end

  it 'should return gpfs' do
    Facter.stubs(:value).with(:hostgroup).returns('base/gpfs')
    expect(Facter.fact(:hostgroup_name).value).to eq('gpfs')
  end

  it 'should return base' do
    Facter.stubs(:value).with(:hostgroup).returns('base')
    expect(Facter.fact(:hostgroup_name).value).to eq('base')
  end
end
