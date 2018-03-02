# puppet-osc_facts

## Usage

The `cluster` fact must be defined as the cluster name. This is can be done by adding a static value to a plain text file

```
mkdir -p /etc/puppetlabs/facter/facts.d
cat > /etc/puppetlabs/facter/facts.d/cluster.txt <<EOF
cluster=example
EOF
```

Cluster must be defined in `files/${cluster}_hosts.yaml`.  Reference `files/example_hosts.yaml`.
