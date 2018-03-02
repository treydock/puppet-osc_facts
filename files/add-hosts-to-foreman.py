#!/usr/bin/env python
# This script is an example.
# The URL value must be updated as well as BMC_USER

import argparse
from getpass import getpass, getuser
import json
import os, sys
import yaml
from ClusterShell.NodeSet import NodeSet
import logging
from foreman_api import ForemanAPI

logger = logging.getLogger()

parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('--bmc-pass', help='path to bmc password file', dest='bmc_pass', required=True)
parser.add_argument('--noop', dest='noop', action='store_true')
parser.add_argument('--no-noop', dest='noop', action='store_false')
parser.add_argument('--debug', dest='debug', action='store_true', default=False)
parser.add_argument('--cluster', dest='cluster', required=True)
parser.add_argument('--yaml', dest='yaml', required=True)
parser.add_argument('--hosts', dest='hosts', help="specific hosts to add/update, can be clustershell accepted noderange", default='all')
parser.add_argument('--add-build', dest='add_build', help="set host to build when added", action='store_true', default=False)
parser.add_argument('--add-overwrite', dest='add_overwrite', help="overwrite DNS/DHCP when added", action='store_true', default=False)
parser.set_defaults(noop=True)
args = parser.parse_args()

if args.debug:
    log_level = logging.DEBUG
else:
    log_level = logging.INFO
if args.noop:
    logging_format = '[%(asctime)s] %(levelname)s: %(message)s [NOOP]'
else:
    logging_format = '[%(asctime)s] %(levelname)s: %(message)s'
logging_datefmt = '%Y-%m-%dT%H:%M:%S'
logger.setLevel(logging_level)
ch = logging.StreamHandler()
formatter = logging.Formatter(logging_format)
ch.setFormatter(formatter)
logger.addHandler(ch)

BMC_USER = 'admin'
URL = ''
USER = getuser()
PASS = getpass("Foreman password: ")

if not os.path.isfile(args.bmc_pass):
    logger.error("Must provide bmc-pass file")
else:
    with open(args.bmc_pass, 'r') as passfile:
        bmc_pass = passfile.read().strip()

api = ForemanAPI(url=URL)
api.auth(user=USER, password=PASS)

with open(args.yaml, 'r') as yamlfile:
    hosts_yaml = yaml.load(yamlfile)
hosts = hosts_yaml.get('%s_hosts' % args.cluster)

hostgroups = []
for name, data in hosts.iteritems():
    if 'hostgroup' not in data:
        continue
    if data['hostgroup'] not in hostgroups:
        hostgroups.append(data['hostgroup'])

foreman_hostgroups = {}
for group in hostgroups:
    hostgroup_data = api.get_data(path='api/hostgroups', params={'search': 'title = %s' % group}, paged=True)
    if not hostgroup_data:
        logger.error("Hostgroup %s not found in Foreman", group)
        sys.exit(1)
    hostgroup = hostgroup_data[0]
    logger.info("HOSTGROUP hostgroup=%s ID=%s", hostgroup['title'], hostgroup['id'])
    foreman_hostgroups[group] = hostgroup['id']

foreman_hosts = {}
for name, group_id in foreman_hostgroups.iteritems():
    host_data = api.get_data(path='api/hosts', params={'hostgroup_id': group_id}, paged=True)
    #print json.dumps(host_data, sort_keys=True, indent=True)
    #sys.exit(0)
    logger.info("Found %s %s hosts in Foreman", len(host_data), name)
    for h in host_data:
        h['name'] = h['name'].split('.')[0]
        h['interfaces'] = {}
        foreman_hosts[h['name']] = h

subnets = api.get_data(path='api/subnets', paged=True)
foreman_subnets = {}
for subnet in subnets:
    foreman_subnets[subnet['name']] = subnet['id']
domains = api.get_data(path='api/domains', paged=True)
foreman_domains = {}
foreman_domain_ids = {}
for domain in domains:
    foreman_domains[domain['name']] = domain['id']
    foreman_domain_ids[domain['id']] = domain['name']

if args.hosts != 'all':
    apply_hosts = list(NodeSet(args.hosts))
else:
    apply_hosts = hosts.keys()

#for name, data in sorted(hosts.items(), reverse=True):
for name, data in sorted(hosts.items()):
    if name not in apply_hosts:
        continue
    exists = None
    # remove data we can't (yet) send to Foreman
    if 'location' in data:
        del data['location']
    if 'extra' in data:
        del data['extra']
    if 'data' in data:
        del data['data']
    fqdn = "%s.%s" % (name, data['domain'])
    # Check if host exists
    exists = foreman_hosts.get(name, None)
    # Handle case where renaming host
    if exists:
        #print json.dumps(exists, indent=4, sort_keys=True)
        fqdn = "%s.%s" % (name, exists['domain_name'])
        foreman_interfaces = api.get_data(path="api/hosts/%s/interfaces" % fqdn, paged=True)
        #print json.dumps(foreman_interfaces, indent=4, sort_keys=True)
        for i in foreman_interfaces:
            iname = i['name']
            exists['interfaces'][iname] = i
        foreman_parameters = api.get_data(path="api/hosts/%s/parameters" % fqdn, paged=True)
        #print json.dumps(foreman_parameters, sort_keys=True, indent=4)
        exists['host_parameters_attributes'] = foreman_parameters
    # Set subnet and domain - should inherit from hostgroup but setting interfaces_attributes seems to break the inherit
    data['domain_id'] = foreman_domains[data['domain']]
    del data['domain']
    data['hostgroup_id'] = foreman_hostgroups[data['hostgroup']]
    del data['hostgroup']
    data['host_parameters_attributes'] = []
    #print json.dumps(data['parameters'], sort_keys=True, indent=4)
    if 'parameters' in data:
        for name, value in data['parameters'].items():
            parameter = {}
            parameter['name'] = name
            parameter['value'] = value
            data['host_parameters_attributes'].append(parameter)
        del data['parameters']

    #print json.dumps(data['host_parameters_attributes'], sort_keys=True, indent=4)
    #print json.dumps(exists, sort_keys=True, indent=4)

    # Fix interface data
    for idx, interface in enumerate(data['interfaces_attributes']):
        if interface['type'] == 'bmc':
            data['interfaces_attributes'][idx]['username'] = BMC_USER
            data['interfaces_attributes'][idx]['password'] = bmc_pass
            data['interfaces_attributes'][idx]['provider'] = 'IPMI'
        if interface.get('domain', None):
            data['interfaces_attributes'][idx]['domain_id'] = foreman_domains[interface['domain']]
            data['interfaces_attributes'][idx]['name'] = "%s.%s" % (interface['name'], interface['domain'])
            del data['interfaces_attributes'][idx]['domain']
        else:
            data['interfaces_attributes'][idx]['domain_id'] = data['domain_id']
            data['interfaces_attributes'][idx]['name'] = "%s.%s" % (interface['name'], foreman_domain_ids[data['domain_id']])
        subnet = interface['subnet']
        del data['interfaces_attributes'][idx]['subnet']
        subnet_id = foreman_subnets[subnet]
        data['interfaces_attributes'][idx]['subnet_id'] = subnet_id
        data['interfaces_attributes'][idx]['managed'] = 'true'
    # Host exists - so check to see if updates are needed
    if exists:
        #print json.dumps(exists, sort_keys=True, indent=4)
        updates = {}
        parameter_updates = {}
        # Check host values that are string or int
        for key, value in data.iteritems():
            if isinstance(value, basestring) or isinstance(value, int):
                if key not in ['ip', 'mac', 'overwrite', 'build']:
                    if str(value).lower() != str(exists[key]).lower():
                        logger.debug("DEBUG: host=%s value mismatch %s, new=%s old=%s", name, key, value, exists[key])
                        updates[key] = value
        # Check host's parameters for updates
        for parameter in data['host_parameters_attributes']:
            existing_parameter = [p for p in exists['host_parameters_attributes'] if p['name'] == parameter['name']]
            if existing_parameter:
                existing_parameter = existing_parameter[0]
            else:
                existing_parameter = {}
            if existing_parameter:
                if parameter['value'] != existing_parameter['value']:
                    parameter_update = {}
                    logger.debug("DEBUG: host=%s parameter value mismatch, new=%s old=%s", name, parameter['value'], existing_parameter['value'])
                    parameter_updates[existing_parameter['id']] = {
                        'name': parameter['name'],
                        'value': parameter['value'],
                    }
            else:
                logger.debug("DEBUG: host=%s parameter value mismatch, new=%s old=None", name, parameter['value'])
                if 'host_parameters_attributes' not in updates:
                    updates['host_parameters_attributes'] = []
                updates['host_parameters_attributes'].append(parameter)
                
            
        # Check host's interfaces for updates
        for interface in data['interfaces_attributes']:
            interface_updates = {}
            existing_interface = exists['interfaces'].get(interface['name'])
            #print json.dumps(interface, sort_keys=True, indent=4)
            #print json.dumps(existing_interface, sort_keys=True, indent=4)
            if existing_interface:
                for key, value in interface.iteritems():
                    if key not in existing_interface or str(value).lower() != str(existing_interface.get(key)).lower():
                        logger.debug("DEBUG: host=%s Interface value mismatch %s, new=%s old=%s", name, key, value, existing_interface.get(key))
                        if 'interfaces_attributes' not in updates:
                            updates['interfaces_attributes'] = []
                        if not interface_updates:
                            #interface_updates = existing_interface
                            interface_updates = {'id': existing_interface['id']}
                            interface_updates['type'] = interface['type']
                        interface_updates[key] = value
                if interface_updates:
                    updates['interfaces_attributes'].append(interface_updates)
            else:
                if 'interfaces_attributes' not in updates:
                    updates['interfaces_attributes'] = []
                logger.debug("DEBUG host=%s Add Interface %s", name, interface['name'])
                updates['interfaces_attributes'].append(interface)
        if updates:
            logger.info("Updating host %s in Foreman", fqdn)
            host_data = {
                'host': updates
            }
            host_data['host']['overwrite'] = True
            print json.dumps(host_data, sort_keys=True, indent=4)
            if args.noop:
                continue
            result = api.send_data(path="api/hosts/%s" % fqdn, data=host_data, method='put')
            if result:
                logger.info("Successfully updated host %s", fqdn)
        if parameter_updates:
            logger.info("Updating host parameters %s in Foreman", fqdn)
            for parameter_id, param_data in parameter_updates.iteritems():
                logger.info("INFO Updating host %s parameter %s in Foreman", fqdn, param_data['name'])
                parameter_data = {
                    "parameter": param_data,
                }
                if args.noop:
                    continue
                result = api.send_data(path="api/hosts/%s/parameters/%s" % (fqdn, parameter_id), data=parameter_data, method='put')
                if result:
                    logger.info("Successfully updated host %s parameter %s", fqdn, param_data['name'])
        if not updates and not parameter_updates:
            logger.info("Host %s up to date in Foreman", fqdn)
        #if False:
        #    logger.info("Update host %s interfaces", fqdn)
        #    for interface_id, idata in interface_updates.iteritems():
        #        interface_data = {
        #            'interface': idata
        #        }
        #        interface_data['interface']['overwrite'] = True
        #        if args.noop:
        #            continue
        #        result = post_request('api/hosts/%s/interfaces/%s' % (fqdn, interface_id), data=interface_data, put=True)
        #        if result:
        #            logger.info("Successfully updated host's interface %s", fqdn)
    # Host does not exist - create
    else:
        # Fix issue where parameters can't be empty
        if not data['host_parameters_attributes']:
            del data['host_parameters_attributes'] 
        logger.info("Adding host %s to Foreman", fqdn)
        host_data = {
            'host': data
        }
        host_data['host']['build'] = args.add_build
        host_data['host']['overwrite'] = args.add_overwrite
        if args.debug:
            print json.dumps(host_data, indent=4, sort_keys=True)
        if args.noop:
            continue
        result = api.send_data(path='api/hosts', data=host_data, method='post')
        if result:
            logger.info("Successfully added host %s", fqdn)
            #print json.dumps(result, indent=4, sort_keys=True)

sys.exit(0)
