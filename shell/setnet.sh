#!/bin/bash

usage() {
    cat <<EOF
A simple wrapper of ipfw to configure Bandwidth, Delay and
Packet Loss Rate of network.

Usage: $0 -b XXX [-d XXX] [-u XXX] -r XXX [-l X]

  -h: Help
  -b: Bandwidth (Kbit/s, uplink & downlink)
  -d: Downlink Bandwidth
  -u: Uplink Bandwidth
  -r: Delay/RTT (ms)
  -l: Packet Loss Rate (0.0~1.0, default to 0)

If you set the Bandwidth of target network with only '-b' option, then
your network will be symmetric, which means bandwidth of both uplink
and downlink is set to the value of the argument of '-b' option.

If you want an asymmetric network, you can use '-d' or '-u' option to
set different bandwidth for downlink or uplink respectively. When one
of them is used, it will override the value set by the '-b' option.
Otherwise, use the value of '-b' option for the other link.
EOF
}

# if invoke this script like 'DEBUG=echo $0 -b 1024 -r 1000',
# nothing will happen.
DEBUG=${DEBUG:- }

if [ $# -eq 0 ];then
    usage
    exit 0
fi

while getopts "hfb:d:u:r:l:" opt; do
    case $opt in
        h)
            usage
            ;;
        f)
            ipfw pipe flush -f
            ipfw flush -f
            echo "Flushed ipfw done."
            exit 0
            ;;
        b)
            BW_ALL="$OPTARG"
            ;;
        d)
            BW_DW="$OPTARG"
            ;;
        u)
            BW_UP="$OPTARG"
            ;;
        r)
            RTT="$OPTARG"
            ;;
        l)
            LOSS="$OPTARG"
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

if [ -z $BW_DW ] || [ -z $BW_UP ]; then
    if [ -z $BW_ALL ]; then
        echo "Please set bandwidth with at least '-b' option."
        exit 1
    fi
fi

BW_DW=${BW_DW:-${BW_ALL}}
BW_UP=${BW_UP:-${BW_ALL}}

if [ -z $RTT ]; then
    echo "Please set Delay/RTT with '-r' option."
    exit 1
fi

# Packet Loss Rate default to 0
if [ -z $LOSS ];then
    LOSS=0
fi

$DEBUG echo "Flushing previous rules..."
$DEBUG ipfw pipe flush -f
$DEBUG ipfw flush -f
$DEBUG echo "Flush done."


$DEBUG ipfw add 1 pipe 1 ip from any to any in   # uplink
$DEBUG ipfw add 2 pipe 2 ip from any to any out  # downlink

# network condition may be not symmetric
# bw: bandwidth, delay: RTT, plr: packet loss
$DEBUG ipfw pipe 1 config bw "${BW_UP}kbit/s" delay "${RTT}ms" plr "$LOSS"
$DEBUG ipfw pipe 2 config bw "${BW_DW}kbit/s" delay "${RTT}ms" plr "$LOSS"
