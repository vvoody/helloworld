#!/bin/bash
check_incrsync_running()
{
    {
        echo "Waiting for the incrsync process running over..."
	    flock -x 3
	    sleep 2
	    echo "I will do until you unlocked." 
    } 3<>"$1"
}

case "$1" in
    start)
        check_incrsync_running /tmp/synclock
        echo "Now we can run..."
        ;;
    *)
        echo "error..."
        ;;
esac

# Test with python -m fcntl.flock
