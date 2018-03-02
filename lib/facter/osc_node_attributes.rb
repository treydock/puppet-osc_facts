#!/usr/bin/env ruby

require 'facter/util/osc'
require 'yaml'

Facter.add('osc_node_attributes') do
  confine :nfsroot => [:true, 'true', true]
  confine :osc_host_type => 'compute'

  setcode do
    value = nil
    cluster = Facter.value(:cluster)
    host_data = Facter::Util::Osc.get_cluster_host_data(cluster)

    if host_data
      if host_data.has_key?('data')
        data = host_data['data']
        if data.has_key?('node_attributes')
          value = data['node_attributes']
        end
      end
    end

    value
  end
end
