require 'spec_helper'
require 'facter/hostgroup_facts'

describe 'hostgroup facts' do
  before { Facter.clear }

  it 'foreman_hostgroup_parent should return base/example for compute' do
    Facter.stubs(:value).with(:hostgroup).returns('base/example/compute')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to eq('base/example')
  end

  it 'foreman_hostgroup_parent should return base/example for batch_server' do
    Facter.stubs(:value).with(:hostgroup).returns('base/example/batch_server')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to eq('base/example')
  end

  it 'foreman_hostgroup_parent should return base' do
    Facter.stubs(:value).with(:hostgroup).returns('base/gpfs')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to eq('base')
  end

  it 'foreman_hostgroup_parent should return nil' do
    Facter.stubs(:value).with(:hostgroup).returns('base')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to be_nil
  end

  it 'foreman_hostgroup_parent should return base/example for compute' do
    Facter.stubs(:value).with(:hostgroup).returns(nil)
    Facter.stubs(:value).with(:foreman_hostgroup).returns('base/example/compute')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to eq('base/example')
  end

  it 'foreman_hostgroup_parent should return base/example for batch_server' do
    Facter.stubs(:value).with(:hostgroup).returns(nil)
    Facter.stubs(:value).with(:foreman_hostgroup).returns('base/example/batch_server')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to eq('base/example')
  end

  it 'foreman_hostgroup_parent should return base' do
    Facter.stubs(:value).with(:hostgroup).returns(nil)
    Facter.stubs(:value).with(:foreman_hostgroup).returns('base/gpfs')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to eq('base')
  end

  it 'foreman_hostgroup_parent should return nil' do
    Facter.stubs(:value).with(:hostgroup).returns(nil)
    Facter.stubs(:value).with(:foreman_hostgroup).returns('base')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_parent).value).to be_nil
  end

  it 'foreman_hostgroup_grandparent should return base for compute' do
    Facter.stubs(:value).with(:hostgroup).returns('base/example/compute')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to eq('base')
  end

  it 'foreman_hostgroup_grandparent should return base for batch_server' do
    Facter.stubs(:value).with(:hostgroup).returns('base/example/batch_server')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to eq('base')
  end

  it 'foreman_hostgroup_grandparent should return nil' do
    Facter.stubs(:value).with(:hostgroup).returns('base/gpfs')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to be_nil
  end

  it 'foreman_hostgroup_grandparent should return nil' do
    Facter.stubs(:value).with(:hostgroup).returns('base')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to be_nil
  end

  it 'foreman_hostgroup_grandparent should return base for compute' do
    Facter.stubs(:value).with(:hostgroup).returns(nil)
    Facter.stubs(:value).with(:foreman_hostgroup).returns('base/example/compute')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to eq('base')
  end

  it 'foreman_hostgroup_grandparent should return base for batch_server' do
    Facter.stubs(:value).with(:hostgroup).returns(nil)
    Facter.stubs(:value).with(:foreman_hostgroup).returns('base/example/batch_server')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to eq('base')
  end

  it 'foreman_hostgroup_grandparent should return nil' do
    Facter.stubs(:value).with(:hostgroup).returns(nil)
    Facter.stubs(:value).with(:foreman_hostgroup).returns('base/gpfs')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to be_nil
  end

  it 'foreman_hostgroup_grandparent should return nil' do
    Facter.stubs(:value).with(:hostgroup).returns(nil)
    Facter.stubs(:value).with(:foreman_hostgroup).returns('base')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_grandparent).value).to be_nil
  end

  it 'foreman_hostgroup_name should return compute' do
    Facter.stubs(:value).with(:hostgroup).returns('base/example/compute')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('compute')
  end

  it 'foreman_hostgroup_name should return batch_server' do
    Facter.stubs(:value).with(:hostgroup).returns('base/example/batch_server')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('batch_server')
  end

  it 'foreman_hostgroup_name should return gpfs' do
    Facter.stubs(:value).with(:hostgroup).returns('base/gpfs')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('gpfs')
  end

  it 'foreman_hostgroup_name should return base' do
    Facter.stubs(:value).with(:hostgroup).returns('base')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('base')
  end

  it 'foreman_hostgroup_name should return compute' do
    Facter.stubs(:value).with(:hostgroup).returns(nil)
    Facter.stubs(:value).with(:foreman_hostgroup).returns('base/example/compute')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('compute')
  end

  it 'foreman_hostgroup_name should return batch_server' do
    Facter.stubs(:value).with(:hostgroup).returns(nil)
    Facter.stubs(:value).with(:foreman_hostgroup).returns('base/example/batch_server')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('batch_server')
  end

  it 'foreman_hostgroup_name should return gpfs' do
    Facter.stubs(:value).with(:hostgroup).returns(nil)
    Facter.stubs(:value).with(:foreman_hostgroup).returns('base/gpfs')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('gpfs')
  end

  it 'foreman_hostgroup_name should return base' do
    Facter.stubs(:value).with(:hostgroup).returns(nil)
    Facter.stubs(:value).with(:foreman_hostgroup).returns('base')
    HostgroupFacts.add_facts
    expect(Facter.fact(:foreman_hostgroup_name).value).to eq('base')
  end
end
