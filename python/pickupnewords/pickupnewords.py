#!/usr/bin/env python

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
    for line in open(filename, 'r'):
        for w in line.split():
            word = w.strip(strip)
            if len(word) >= 2:
                words.append(word.lower())
    return words

if __name__ == "__main__":
    if len(sys.argv) == 1:
        print "Where the file(s)?"
        sys.exit()
    else:
        wordslist = []
        for f in sys.argv[1:]:
            wordslist += pickup_words(f)
        new_words = set(wordslist)
        old_words = pickle.load(open('oxford3k.dat', 'r'))
        print new_words - old_words
