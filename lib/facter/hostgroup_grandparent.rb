#!/usr/bin/env ruby

Facter.add('hostgroup_grandparent') do
  setcode do
    value = nil
    hostgroup = Facter.value(:hostgroup)
    if hostgroup
      hostgroup_parts = hostgroup.split('/')
      if hostgroup_parts.size >= 3
        value = hostgroup_parts[0...-2].join('/')
      end
    end

    value
  end
end
