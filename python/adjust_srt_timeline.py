#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# Some srt subtitile is slower or faster. This little script can adjust it.
#
# Usage: python adjust_srt_timeline.py your_movie.srt delay_second
# e.g.   python adjust_srt_timeline.py Shortbus.chs.srt -8.5
#
# Then there will be a "Shortbus.chs.srt_new" file.
#
# Copyright (C) 2008, vvoody <wxj.g.sh{AT}gmail.com>
# GPLv3 applies ;-)

import sys, re, datetime

def get_new_timeline(old_timeline, sec, microsec):
    '''Add or subtract the timeline and return a new timeline string.

    This function can receive the argument like:
    00:12:59,123  or
    00:12:59.123

    Return the new one like:
    00:13:01,583

    You can substitute "." for "," manually after returning.
    '''

    hour, minute, second, millisecond = \
        map(int, (re.split(r'[:,\.]', old_timeline) ))

    # We must set the year, month, day. It cannont be left none.
    new_timeline = datetime.datetime(2000, 1, 1, hour, minute, second, millisecond*1000) + \
        datetime.timedelta(seconds=sec, microseconds=microsec)

    return '%02d:%02d:%02d,%03d' % \
        (new_timeline.hour, new_timeline.minute, new_timeline.second, new_timeline.microsecond/1000)

try:
    old_srt_name = sys.argv[1]
    old_srt = open(old_srt_name, "r")
except IOError:
    print >> sys.stderr, "Failed to open your srt file!\n"

try:
    new_srt_name = sys.argv[1] + "_new"
    new_srt = open(new_srt_name, "w")
except IOError:
    print >> sys.stderr, "Failed to create a new srt file!\n"

print "Start..."

# Support .000000 ~ .999999, but .0 ~ .9 is enough.
delay = (float)(sys.argv[2])
second = (int)(delay)
microsecond = (int)(1000000*(delay - second))

# A timeline is like -> "00:12:59,123    ->    00:13:00,291"
modetext = re.compile(r"(\d{2}:\d{2}:\d{2}[.,]\d{3}).*(\d{2}:\d{2}:\d{2}[.,]\d{3})")

for line in old_srt:
    if re.match(modetext, line):
        timeline_start, timeline_end = re.match(modetext, line).groups()

        new_timeline_start = get_new_timeline( timeline_start, second, microsecond )
        new_timeline_end = get_new_timeline( timeline_end, second, microsecond )

        line = line.replace( timeline_start, new_timeline_start )
        line = line.replace( timeline_end, new_timeline_end )
        # Print a dot when one line adjusted.
        print '.',

    new_srt.write(line)
# End of FOR

print
print "Adjust successfully!"

old_srt.close()
new_srt.close()

# End of script.
