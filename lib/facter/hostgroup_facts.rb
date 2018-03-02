#!/usr/bin/env ruby

module HostgroupFacts
  def self.add_facts
    Facter.add('foreman_hostgroup_parent') do
      setcode do
        value = nil
        hostgroup = Facter.value(:hostgroup) || Facter.value(:foreman_hostgroup)
        if hostgroup
          hostgroup_parts = hostgroup.split('/')
          if hostgroup_parts.size >= 2
            value = hostgroup_parts[0...-1].join('/')
          end
        end

        value
      end
    end

    Facter.add('foreman_hostgroup_grandparent') do
      setcode do
        value = nil
        hostgroup = Facter.value(:hostgroup) || Facter.value(:foreman_hostgroup)
        if hostgroup
          hostgroup_parts = hostgroup.split('/')
          if hostgroup_parts.size >= 3
            value = hostgroup_parts[0...-2].join('/')
          end
        end

        value
      end
    end

    Facter.add('foreman_hostgroup_name') do
      setcode do
        value = nil
        hostgroup = Facter.value(:hostgroup) || Facter.value(:foreman_hostgroup)
        if hostgroup
          hostgroup_parts = hostgroup.split('/')
          value = hostgroup_parts[-1]
        end

        value
      end
    end


  end
end

HostgroupFacts.add_facts
