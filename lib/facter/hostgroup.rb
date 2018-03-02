#!/usr/bin/env ruby

require 'facter/util/osc'
require 'yaml'

Facter.add('hostgroup') do
  setcode do
    value = nil
    if Facter.value(:nfsroot)
      cluster = Facter.value(:cluster)
      host_data = Facter::Util::Osc.get_cluster_host_data(cluster)

      if host_data
        if host_data.has_key?('hostgroup')
          value = host_data['hostgroup']
        end
      end
    else
      facts_file = nil
      [
        '/etc/facter/facts.d/facts.txt',
        '/etc/puppetlabs/facter/facts.d/facts.txt',
        '/opt/puppetlabs/facter/facts.d/facts.txt',
      ].each do |f|
        if File.exists?(f)
          facts_file = f
          break
        end
      end
      if facts_file
        facts = File.read(facts_file)
        facts.each_line do |line|
          if line =~ /^hostgroup=/
            value = line[/^hostgroup=(.*)$/, 1]
          end
        end
      end
    end
    value
  end
end
