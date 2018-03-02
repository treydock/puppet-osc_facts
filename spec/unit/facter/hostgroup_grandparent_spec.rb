require 'spec_helper'

describe 'hostgroup_grandparent fact' do
  before { Facter.clear }

  it 'should return base for compute' do
    Facter.stubs(:value).with(:hostgroup).returns('base/example/compute')
    expect(Facter.fact(:hostgroup_grandparent).value).to eq('base')
  end

  it 'should return base for batch_server' do
    Facter.stubs(:value).with(:hostgroup).returns('base/example/batch_server')
    expect(Facter.fact(:hostgroup_grandparent).value).to eq('base')
  end

  it 'should return nil' do
    Facter.stubs(:value).with(:hostgroup).returns('base/gpfs')
    expect(Facter.fact(:hostgroup_grandparent).value).to be_nil
  end

  it 'should return nil' do
    Facter.stubs(:value).with(:hostgroup).returns('base')
    expect(Facter.fact(:hostgroup_grandparent).value).to be_nil
  end
end
