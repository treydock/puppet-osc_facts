#!/usr/bin/env ruby

Facter.add('rhsm_release') do
  confine :nfsroot_ro => [:false, 'false', false]
  confine :operatingsystem => 'RedHat'

  setcode do 
    value = nil
    output = Facter::Util::Resolution.exec('/usr/sbin/subscription-manager release --show 2>/dev/null')
    if output =~ /Release not set/
      value = 'unset'
    else
      if output =~ /^Release: (.*)$/
        value = $1
      end
    end
    value
  end
end
