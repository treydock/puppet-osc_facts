#
class osc_facts {

  include ::facter

  if $::cluster {
    $_cluster_file_source = "puppet:///modules/osc_facts/${::cluster}_hosts.yaml"
    # These paths are purposely hardcoded as the paths also must be updated in lib/facter/util/osc.rb
    $_cluster_file        = "/usr/local/etc/${::cluster}_hosts.yaml"
    $_cluster_file_ruby   = "/usr/local/etc/${::cluster}_hosts.marshal"
    $_cluster_file_python = "/usr/local/etc/${::cluster}_hosts.cpickle"
    file { $_cluster_file:
      ensure => 'file',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => $_cluster_file_source,
      notify => [
        Exec['marshal-cluster-yaml'],
        Exec['pickle-cluster-yaml'],
      ],
    }
  }

  file { '/usr/local/bin/yaml-pickle.py':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/osc_facts/yaml-pickle.py',
  }

  file { '/usr/local/bin/yaml-marshal.rb':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/osc_facts/yaml-marshal.rb',
  }

  exec { 'marshal-cluster-yaml':
    command     => "/usr/local/bin/yaml-marshal.rb ${_cluster_file} ${_cluster_file_ruby}",
    refreshonly => true,
    require     => File['/usr/local/bin/yaml-marshal.rb'],
  }

  exec { 'pickle-cluster-yaml':
    command     => "/usr/local/bin/yaml-pickle.py ${_cluster_file} ${_cluster_file_python}",
    refreshonly => true,
    require     => File['/usr/local/bin/yaml-pickle.py'],
  }

}
