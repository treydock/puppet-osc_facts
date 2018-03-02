require 'spec_helper'


describe 'rhsm_release Fact' do
  before :each do
    Facter.fact(:operatingsystem).stubs(:value).returns('RedHat')
  end

  it 'returns unset when release not set' do
    Facter.fact(:nfsroot_ro).stubs(:value).returns(false)
    Facter::Util::Resolution.expects(:exec).with('/usr/sbin/subscription-manager release --show 2>/dev/null').returns('Release not set')
    expect(Facter.fact(:rhsm_release).value).to eq('unset')
  end

  it 'returns 7.2' do
    Facter.fact(:nfsroot_ro).stubs(:value).returns(false)
    Facter::Util::Resolution.expects(:exec).with('/usr/sbin/subscription-manager release --show 2>/dev/null').returns('Release: 7.2')
    expect(Facter.fact(:rhsm_release).value).to eq('7.2')
  end

  it 'returns 7Server' do
    Facter.fact(:nfsroot_ro).stubs(:value).returns(false)
    Facter::Util::Resolution.expects(:exec).with('/usr/sbin/subscription-manager release --show 2>/dev/null').returns('Release: 7Server')
    expect(Facter.fact(:rhsm_release).value).to eq('7Server')
  end

  it 'returns nil' do
    Facter.fact(:nfsroot_ro).stubs(:value).returns(true)
    Facter::Util::Resolution.expects(:exec).with('/usr/sbin/subscription-manager release --show 2>/dev/null').never
    expect(Facter.fact(:rhsm_release).value).to be_nil
  end
end
