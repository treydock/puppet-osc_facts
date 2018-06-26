#!/usr/bin/env ruby

require 'facter/util/osc'
require 'yaml'

Facter.add('osc_rw_type') do
  confine :osc_host_type => 'rw'

  setcode do
    value = 'none'
    cluster = Facter.value(:cluster)
    if cluster.nil?
      host_data = nil
    else
      host_data = Facter::Util::Osc.get_cluster_host_data(cluster)
    end

    if host_data
      if host_data.has_key?('extra')
        extra = host_data['extra']
        if extra.has_key?('rw_type')
          value = extra['rw_type']
        end
      end
    end

    value
  end
end
