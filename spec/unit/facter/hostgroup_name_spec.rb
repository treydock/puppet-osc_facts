require 'spec_helper'

describe 'hostgroup_name fact' do
  before { Facter.clear }

  it 'should return compute' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/example/compute')
    expect(Facter.fact(:hostgroup_name).value).to eq('compute')
  end

  it 'should return batch_server' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/example/batch_server')
    expect(Facter.fact(:hostgroup_name).value).to eq('batch_server')
  end

  it 'should return gpfs' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/gpfs')
    expect(Facter.fact(:hostgroup_name).value).to eq('gpfs')
  end

  it 'should return base' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base')
    expect(Facter.fact(:hostgroup_name).value).to eq('base')
  end
end
