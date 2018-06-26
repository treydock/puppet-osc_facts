require 'spec_helper'

describe 'hostgroup_parent fact' do
  before { Facter.clear }

  it 'should return base/example for compute' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/example/compute')
    expect(Facter.fact(:hostgroup_parent).value).to eq('base/example')
  end

  it 'should return base/example for batch_server' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/example/batch_server')
    expect(Facter.fact(:hostgroup_parent).value).to eq('base/example')
  end

  it 'should return base' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/gpfs')
    expect(Facter.fact(:hostgroup_parent).value).to eq('base')
  end

  it 'should return nil' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base')
    expect(Facter.fact(:hostgroup_parent).value).to be_nil
  end
end
