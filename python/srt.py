#!/usr/bin/python
# -*- coding: utf-8 -*-
#
# Adjust your srt subtitile file for the right timeline.
#
# Usage: adjust_srt_timeline.py your_movie.srt 9 [-9]
#
# I just add or subtract the seconds from the original timeline.
# But that is enough for me.
#
# adjust_srt_timeline.py Copyright (C) vvoody <wxj.g.sh{AT}gmail.com>
#
# GPL v3 applies ;-)
#
# Python module timeItv Copyright (C) 城市拓荒者 <http://wibrst.cublog.cn/>
# For more 'timeItv' infomation, refer to:
# http://www.cublog.cn/u/28253/showart_289137.html
#

import sys, re
from timeItv import time2itv, itv2time

old_srt_name = sys.argv[1]
old_srt = open(old_srt_name, "r")

new_srt_name = sys.argv[1] + "_new"
new_srt = open(new_srt_name, "w")

print "Start..."

offset = (int)(sys.argv[2])
# like 00:12:59
regexp = re.compile(r"(\d{2}:\d{2}:\d{2}).*(\d{2}:\d{2}:\d{2})")

for line in old_srt.readlines():
    if re.match(regexp, line):
        timeline1 = re.match(regexp, line).group(1)
        timeline2 = re.match(regexp, line).group(2)
        new_timeline1 = itv2time(time2itv(timeline1) + offset)
        new_timeline2 = itv2time(time2itv(timeline2) + offset)
        line = line.replace(timeline1, new_timeline1)
        line = line.replace(timeline2, new_timeline2)
        # Print a dot when one line adjusted.
        print ".",

    new_srt.write(line)

old_srt.close()
new_srt.close()

print
print "Adjust successfully!"
