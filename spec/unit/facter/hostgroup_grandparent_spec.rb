require 'spec_helper'

describe 'hostgroup_grandparent fact' do
  before { Facter.clear }

  it 'should return base for compute' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/example/compute')
    expect(Facter.fact(:hostgroup_grandparent).value).to eq('base')
  end

  it 'should return base for batch_server' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/example/batch_server')
    expect(Facter.fact(:hostgroup_grandparent).value).to eq('base')
  end

  it 'should return nil' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/gpfs')
    expect(Facter.fact(:hostgroup_grandparent).value).to be_nil
  end

  it 'should return nil' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base')
    expect(Facter.fact(:hostgroup_grandparent).value).to be_nil
  end
end
