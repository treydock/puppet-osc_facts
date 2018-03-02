#!/usr/bin/env ruby

Facter.add('hostgroup_name') do
  setcode do
    value = nil
    hostgroup = Facter.value(:hostgroup)
    if hostgroup
      hostgroup_parts = hostgroup.split('/')
      value = hostgroup_parts[-1]
    end

    value
  end
end
