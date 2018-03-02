#!/usr/bin/env ruby

Facter.add('hostgroup_parent') do
  setcode do
    value = nil
    hostgroup = Facter.value(:hostgroup)
    if hostgroup
      hostgroup_parts = hostgroup.split('/')
      if hostgroup_parts.size >= 2
        value = hostgroup_parts[0...-1].join('/')
      end
    end

    value
  end
end
