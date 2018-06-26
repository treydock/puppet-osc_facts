require 'spec_helper'
require 'facter/hostgroup_facts'

describe 'hostgroup facts' do
  before { Facter.clear }

  it 'foreman_hostgroup_parent should return base/example for compute' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/example/compute')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to eq('base/example')
  end

  it 'foreman_hostgroup_parent should return base/example for batch_server' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/example/batch_server')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to eq('base/example')
  end

  it 'foreman_hostgroup_parent should return base' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/gpfs')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to eq('base')
  end

  it 'foreman_hostgroup_parent should return nil' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to be_nil
  end

  it 'foreman_hostgroup_parent should return base/example for compute' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return(nil)
    allow(Facter).to receive(:value).with(:foreman_hostgroup).and_return('base/example/compute')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to eq('base/example')
  end

  it 'foreman_hostgroup_parent should return base/example for batch_server' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return(nil)
    allow(Facter).to receive(:value).with(:foreman_hostgroup).and_return('base/example/batch_server')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to eq('base/example')
  end

  it 'foreman_hostgroup_parent should return base' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return(nil)
    allow(Facter).to receive(:value).with(:foreman_hostgroup).and_return('base/gpfs')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to eq('base')
  end

  it 'foreman_hostgroup_parent should return nil' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return(nil)
    allow(Facter).to receive(:value).with(:foreman_hostgroup).and_return('base')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to be_nil
  end

  it 'foreman_hostgroup_grandparent should return base for compute' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/example/compute')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to eq('base')
  end

  it 'foreman_hostgroup_grandparent should return base for batch_server' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/example/batch_server')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to eq('base')
  end

  it 'foreman_hostgroup_grandparent should return nil' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/gpfs')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to be_nil
  end

  it 'foreman_hostgroup_grandparent should return nil' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to be_nil
  end

  it 'foreman_hostgroup_grandparent should return base for compute' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return(nil)
    allow(Facter).to receive(:value).with(:foreman_hostgroup).and_return('base/example/compute')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to eq('base')
  end

  it 'foreman_hostgroup_grandparent should return base for batch_server' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return(nil)
    allow(Facter).to receive(:value).with(:foreman_hostgroup).and_return('base/example/batch_server')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to eq('base')
  end

  it 'foreman_hostgroup_grandparent should return nil' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return(nil)
    allow(Facter).to receive(:value).with(:foreman_hostgroup).and_return('base/gpfs')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to be_nil
  end

  it 'foreman_hostgroup_grandparent should return nil' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return(nil)
    allow(Facter).to receive(:value).with(:foreman_hostgroup).and_return('base')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to be_nil
  end

  it 'foreman_hostgroup_name should return compute' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/example/compute')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('compute')
  end

  it 'foreman_hostgroup_name should return batch_server' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/example/batch_server')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('batch_server')
  end

  it 'foreman_hostgroup_name should return gpfs' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base/gpfs')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('gpfs')
  end

  it 'foreman_hostgroup_name should return base' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return('base')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('base')
  end

  it 'foreman_hostgroup_name should return compute' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return(nil)
    allow(Facter).to receive(:value).with(:foreman_hostgroup).and_return('base/example/compute')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('compute')
  end

  it 'foreman_hostgroup_name should return batch_server' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return(nil)
    allow(Facter).to receive(:value).with(:foreman_hostgroup).and_return('base/example/batch_server')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('batch_server')
  end

  it 'foreman_hostgroup_name should return gpfs' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return(nil)
    allow(Facter).to receive(:value).with(:foreman_hostgroup).and_return('base/gpfs')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('gpfs')
  end

  it 'foreman_hostgroup_name should return base' do
    allow(Facter).to receive(:value).with(:hostgroup).and_return(nil)
    allow(Facter).to receive(:value).with(:foreman_hostgroup).and_return('base')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('base')
  end
end
