#!/usr/bin/env ruby

require 'facter/util/osc'
require 'yaml'

Facter.add(:ipoib_address_ib0) do
  confine :nfsroot => [:true, 'true', true]
  setcode do
    value = nil
    cluster = Facter.value(:cluster)
    host_data = Facter::Util::Osc.get_cluster_host_data(cluster)
    if host_data
      if host_data.has_key?('interfaces_attributes')
        interfaces_attributes = host_data['interfaces_attributes']
        interfaces_attributes.each do |interface_attributes|
          if interface_attributes['identifier'] == 'ib0'
            value = interface_attributes['ip']
          end
        end
      end
    end
    value
  end
end
