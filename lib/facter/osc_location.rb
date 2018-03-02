#!/usr/bin/env ruby

require 'facter/util/osc'
require 'yaml'

Facter.add('osc_location') do
  confine :nfsroot => true

  setcode do
    value = nil
    cluster = Facter.value(:cluster)
    host_data = Facter::Util::Osc.get_cluster_host_data(cluster)

    if host_data
      if host_data.has_key?('location')
        value = host_data['location']
      end
    end
    value
  end
end
