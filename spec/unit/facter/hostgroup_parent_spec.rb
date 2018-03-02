require 'spec_helper'

describe 'hostgroup_parent fact' do
  before { Facter.clear }

  it 'should return base/example for compute' do
    Facter.stubs(:value).with(:hostgroup).returns('base/example/compute')
    expect(Facter.fact(:hostgroup_parent).value).to eq('base/example')
  end

  it 'should return base/example for batch_server' do
    Facter.stubs(:value).with(:hostgroup).returns('base/example/batch_server')
    expect(Facter.fact(:hostgroup_parent).value).to eq('base/example')
  end

  it 'should return base' do
    Facter.stubs(:value).with(:hostgroup).returns('base/gpfs')
    expect(Facter.fact(:hostgroup_parent).value).to eq('base')
  end

  it 'should return nil' do
    Facter.stubs(:value).with(:hostgroup).returns('base')
    expect(Facter.fact(:hostgroup_parent).value).to be_nil
  end
end
