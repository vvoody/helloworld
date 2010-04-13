#!/usr/bin/env python
# -*- coding: utf-8 -*-
# The Oxford 3000 wordlist - http://is.gd/bpikU
#
#   1. Emacs C-x r d
#   2. cat oxford3000.txt | awk '{print $1}' | sort | uniq > oxford3k.txt
#   3. set(oxford3k.txt) pickle -> oxford3k.dat (case insensitive)

import sys
import string
import pickle

def pickup_words(filename):
    """Find out the words from a file and return a list.
    """

    strip = string.whitespace + string.punctuation + string.digits + "\"'"
    words = []
    with open(filename, 'r') as f:
        for line in f:
            for w in line.split():
                w = w.strip(strip)
                if len(w) >= 2:
                    words.append(w.lower())
    return words

help_doc = """
0,9,13, 21
all
!0,9,13,21
!all -> RET
"""

if __name__ == "__main__":
    if len(sys.argv) == 1:
        print "Where the file(s)?"
        sys.exit()
    else:
        wordslist = []
        for f in sys.argv[1:]:
            wordslist += pickup_words(f)
        oldf = open('oldwords.dat', 'r+')
        old_words = pickle.load(oldf)
        oldf.seek(0)
        new_words = list(set(wordslist) - old_words)
        for i in range(len(new_words)):
            print i, '"%s"' % new_words[i]
        #sys.exit()
        # Store the words you have already known, cmd not check carefully
        cmd = raw_input("Stroe the words already known: ").strip(' ,')
        if cmd [:1] == '?' or cmd[:1] == 'h' or cmd[:4] == 'help':
            print help_doc
        # all words are new
        elif cmd[:4] == '!all' or cmd == '!' or cmd == '':
            pass
        # all words are known
        elif cmd[:3] == 'all':
            old_words = old_words.union(set(new_words))
            pickle.dump(old_words, oldf)
        # Store except
        elif cmd[0] == '!':
            old_words= old_words.union(
                set(new_words) -
                set([new_words[int(i)] for i in cmd[1:].split(',')])
                )
            pickle.dump(old_words, oldf)
        # Store exactly
        elif cmd[0] in '1234567890':
            old_words= old_words.union(
                set([new_words[int(i)] for i in cmd[1:].split(',')])
                )
            pickle.dump(old_words, oldf)
        else:
            print "Unknown command!"
        #
        oldf.close()
# EOF
