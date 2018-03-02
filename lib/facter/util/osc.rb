require 'yaml'

class Facter::Util::Osc
  CPU_MATCHERS = [
    {
      :codename => 'broadwell',
      :match    => /Xeon.*E(3|5|7)-[0-9]{4} v4/,
    },
    {
      :codename => 'haswell',
      :match    => /Xeon.*E(3|5|7)-[0-9]{4} v3/,
    },
  ]

  #def self.get_facts_dot_d_dir(file)
  #  Facter::Util::Config.external_facts_dirs.each do |dir|
  #    if File.exists?(File.join(File.dirname(dir), file))
  #      return dir
  #    end
  #  end
  #end

  def self.load_data(cluster)
    yaml_file = "/usr/local/etc/#{cluster}_hosts.yaml"
    marshal_file = "/usr/local/etc/#{cluster}_hosts.marshal"
    if File.exist?(marshal_file)
      File.open(marshal_file, 'r') do |f|
        data = Marshal.load(f)
      end
    elsif File.exist?(yaml_file)
      data = YAML.load_file(yaml_file)
    else
      return nil
    end
  end

  def self.get_cluster_host_data(cluster)
    #facts_dir = self.get_facts_dot_d_dir('owens_hosts.yaml')
    #yaml_file = File.join(facts_dir, 'owens_hosts.yaml')
    data = self.load_data(cluster)
    if ! data
      return nil
    end
    if ! data.has_key?("#{cluster}_hosts")
      return nil
    end
    hosts = data["#{cluster}_hosts"]
    hostname = Facter.value(:hostname)
    if ! hosts.has_key?(hostname)
      return nil
    end
    data = hosts[hostname]
    return data
  end

  # Returns the matching CPU codename
  #
  # @return [String]
  #
  # @api private
  def self.cpu_codename(cpu)
    codename = nil

    CPU_MATCHERS.each do |matcher|
      match = cpu.match(matcher[:match])
      if match
        codename = matcher[:codename]
      end
    end

    codename
  end
end
