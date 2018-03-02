# Fact: cpu_codename
#
# Purpose: Return the CPU codename.
#

require 'facter/util/osc'

Facter.add('cpu_codename') do
  setcode do
    cpu = Facter.value(:processor0)
    codename = Facter::Util::Osc.cpu_codename(cpu)
    codename
  end
end
