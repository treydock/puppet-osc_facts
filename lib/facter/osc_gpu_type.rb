#!/usr/bin/env ruby

require 'facter/util/osc'
require 'yaml'

Facter.add('osc_gpu_type') do
  confine :nfsroot => [:true, 'true', true]
  confine :osc_compute_type => 'gpu'

  setcode do
    value = nil
    cluster = Facter.value(:cluster)
    host_data = Facter::Util::Osc.get_cluster_host_data(cluster)

    if host_data
      if host_data.has_key?('extra')
        extra = host_data['extra']
        if extra.has_key?('gpu_type')
          value = extra['gpu_type']
        end
      end
    end

    value
  end
end
