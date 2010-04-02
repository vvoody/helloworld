#/usr/bin/env python
# -*- coding: utf-8 -*-

import os

def GetNicInfo(addr_cmd='ip add ls',
               route_cmd='ip route ls',
               hostname_cmd='hostname'):
    """
    Get the network interfaces infomation from the following commands:

        add_cmd: 'ip add ls'
        route_cmd: 'ip route ls'
        hostname_cmd: 'hostname'

    Return a dictionary like:

        nics={"eth0":{"type":"E",
                      "mac":"00:12:AB:CD:EF:AA",
                      "addr":"10.200.1.2/24",
                      "hostname":"toolinux.chaoseternal.net",
                      "route":"10.200.1.254"},
              "eth1":{"type":"E",
                      "mac":"00:AA:BB:CC:DD:EE",
                      "addr":['10.200.1.5/24', '10.200.1.6/24'],
                      "hostname":"yadayadayda",
                      "route":"10.200.1.254"}
    """

    # get system commands result
    addr_raw = os.popen(addr_cmd).readlines()
    route_raw = os.popen(route_cmd).readlines()
    hostname_raw = os.popen(hostname_cmd).readlines()

    # get nic name, 'type', 'addr' and 'mac'
    names = []  # ['eth0', 'tun0']
    for name in filter(lambda x: x.find('mtu') >= 0 and x.find('lo') == -1,
                       addr_raw):
        names.append(name.split(':')[1].strip())

    types = []  # ['ether', '[65534]']
    macs = []   # ['00:12:AB:CD:EF:AA', '00:AA:BB:CC:DD:EE']
    for tp in filter(lambda x: x.find('link/') >= 0 and
                     x.find('loopback') == -1,
                     addr_raw):
        types.append(tp.split('/')[1].split(' ')[0])
        macs.append(tp.split(' ')[5] != '\n' and tp.split(' ')[5]  or 'None')
    nic_type = {'ether': 'E', '[65534]': 'tun'}
    types = map(lambda x: x in
                nic_type and x.replace(x, nic_type[x]) or x,
                types)

    # [[]] * len(names) [['192.168.1.100', '192.168.1.101'], ['10.8.0.1']]
    addrs = [[] for i in range(len(names))]
    i = 0
    for addr in filter(lambda x: x.find('inet ') >= 0 and x.find('lo\n') == -1,
                       addr_raw):
        if addr.find(names[i]) >= 0:
            addrs[i].append(addr.split(' ')[5])
        else:
            i += 1
            addrs.append([])
            if addr.find(names[i]) >= 0:
                addrs[i].append(addr.split(' ')[5])

    # get 'hostname'
    hostname = hostname_raw[0].rstrip('\n')

    # get 'route'
    routes = filter(lambda x: x.find('default') >= 0, route_raw)
    route = routes[0].split(' ')[2]

    # gather stuff, filter no ip addr nics
    nics = [[names[j], [
                        ['type', types[j]],
                        ['mac', macs[j]],
                        ['addr', addrs[j]],
                        ['hostname', hostname],
                        ['route', route]]]
            for j in range(len(names)) if addrs[j] != []]
    for i in range(len(nics)):
        nics[i][1] = dict(nics[i][1])
    return dict(nics)

if __name__ == "__main__":
    print GetNicInfo()
