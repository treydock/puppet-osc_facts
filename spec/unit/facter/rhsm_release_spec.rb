require 'spec_helper'

describe 'rhsm_release Fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:operatingsystem)).to receive(:value).and_return('RedHat')
    allow(Facter.fact(:nfsroot_ro)).to receive(:value).and_return(false)
  end

  it 'returns unset when release not set' do
    allow(Facter::Util::Resolution).to receive(:exec).with('/usr/sbin/subscription-manager release --show 2>/dev/null').and_return('Release not set')
    expect(Facter.fact(:rhsm_release).value).to eq('unset')
  end

  it 'returns 7.2' do
    allow(Facter::Util::Resolution).to receive(:exec).with('/usr/sbin/subscription-manager release --show 2>/dev/null').and_return('Release: 7.2')
    expect(Facter.fact(:rhsm_release).value).to eq('7.2')
  end

  it 'returns 7Server' do
    allow(Facter::Util::Resolution).to receive(:exec).with('/usr/sbin/subscription-manager release --show 2>/dev/null').and_return('Release: 7Server')
    expect(Facter.fact(:rhsm_release).value).to eq('7Server')
  end

  it 'returns nil' do
    allow(Facter.fact(:nfsroot_ro)).to receive(:value).and_return(true)
    expect(Facter::Util::Resolution).not_to receive(:exec).with('/usr/sbin/subscription-manager release --show 2>/dev/null')
    expect(Facter.fact(:rhsm_release).value).to be_nil
  end
end
