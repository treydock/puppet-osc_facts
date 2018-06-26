#!/usr/bin/env python

import argparse
import logging
import glob
import json
import cPickle
import socket
import re
import sys
import os

DATA_DIR = '/opt/osc/etc'
DATA_GLOB = '*_hosts.cpickle'
CLUSTER_RE = '(.*)_hosts.cpickle'

logger = logging.getLogger()

def check_cluster_data():
    data_file = None
    files = glob.glob(os.path.join(DATA_DIR, DATA_GLOB))
    for f in files:
        data_file = f
        break
    return data_file

def get_cluster(data_file):
    cluster = None
    basename = os.path.basename(data_file)
    m = re.search(CLUSTER_RE, basename)
    if m:
        cluster = m.group(1)
    return cluster

def load_data_file(data_file, cluster):
    data = {}
    with open(data_file, 'r') as f:
        data = cPickle.load(f)
    data_key = "%s_hosts" % cluster
    if data_key in data:
        return data[data_key]
    return data

def default_host():
    if 'FACTER_hostname' in os.environ:
        fqdn = os.environ.get('FACTER_hostname')
    elif 'HOSTNAME' in os.environ:
        fqdn = os.environ.get('HOSTNAME')
    else:
        fqdn = socket.gethostname()
    host = fqdn.split('.')[0]
    return host

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--debug', help="show debug output", action="store_true", default=False)
    parser.add_argument('--host', help="host", default=default_host())
    args, unknown_args = parser.parse_known_args()

    if args.debug:
        log_level = logging.DEBUG
    else:
        log_level = logging.INFO
    logger.setLevel(log_level)
    ch = logging.StreamHandler()
    ch.setLevel(log_level)
    formatter = logging.Formatter('[%(asctime)s] %(levelname)s: %(message)s')
    ch.setFormatter(formatter)
    logger.addHandler(ch)

    data_file = check_cluster_data()
    if not data_file:
        logger.debug("Data file not found")
        sys.exit(0)
    cluster = get_cluster(data_file)
    if not cluster:
        logger.debug("Cluster unknown")
        sys.exit(0)
    data = load_data_file(data_file, cluster)
    if not data:
        logger.debug("No data could be loaded")
        sys.exit(0)
    if args.host not in data:
        logger.debug("Hostname could not be determined")
        sys.exit(0)
    host_data = data[args.host]
    values = {
        'osc_partition_schema': 'default'
    }
    if 'extra' in host_data:
        if 'partition_schema' in host_data['extra']:
            values['osc_partition_schema'] = host_data['extra']['partition_schema']
        if 'type' in host_data['extra']:
            values['osc_host_type'] = host_data['extra']['type']
            if values['osc_host_type'] == 'rw' and 'rw_type' in host_data['extra']:
                values['osc_rw_type'] = host_data['extra']['rw_type']
        if 'compute_type' in host_data['extra']:
            values['osc_compute_type'] = host_data['extra']['compute_type']
            if values['osc_compute_type'] == 'gpu' and 'gpu_type' in host_data['extra']:
                values['osc_gpu_type'] = host_data['extra']['gpu_type']
    if 'location' in host_data:
        values['osc_location'] = host_data['location']
    if values:
        print json.dumps(values)

if __name__ == '__main__':
    main()
