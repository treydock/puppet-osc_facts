#!/usr/bin/env ruby

require 'facter/util/osc'
require 'yaml'

Facter.add('osc_partition_schema') do
  confine :nfsroot => [:true, 'true', true]

  setcode do
    value = 'default'
    cluster = Facter.value(:cluster)
    host_data = Facter::Util::Osc.get_cluster_host_data(cluster)

    if host_data
      if host_data.has_key?('extra')
        extra = host_data['extra']
        if extra.has_key?('partition_schema')
          value = extra['partition_schema']
        end
      end
    end

    value
  end
end
