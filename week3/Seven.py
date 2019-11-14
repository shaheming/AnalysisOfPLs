
#!/usr/bin/python3
import collections
import re
import sys
# Mileage may vary. If this crashes, make it lower
RECURSION_LIMIT = 500
# We add a few more, because, contrary to the name, # this doesn’t just rule recursion: it rules the
# depth of the call stack sys.setrecursionlimit(RECURSION_LIMIT+10)
# What to do with an empty list

stop_words = set(open("../stop_words.txt").read().split(","))

words = re.findall("[a-z]{2,}", open(sys.argv[1]).read().lower())

word_freqs = collections.defaultdict(lambda: 0)


Y = (lambda h: lambda F: F(lambda x: h(h)(F)(x)))(lambda h: lambda F: F(lambda x: h(h)(F)(x)))

COUNT = Y(lambda f: lambda word_list: lambda stopwords: lambda word_freqs: word_list[0] not in stop_words and word_freqs.update(
    {word_list[0]: word_freqs[word_list[0]]+1}) and False or f(word_list[1:])(stop_words)(word_freqs) if len(word_list) > 0 else False)
PRINT = Y(lambda f: lambda n: print(
    n[0][0], '-', n[0][1]) or f(n[1:]) if len(n) > 0 else False)

for i in range(0, len(words), RECURSION_LIMIT):
    COUNT(words[i:i+RECURSION_LIMIT])(stop_words)(word_freqs)

PRINT(sorted(word_freqs.items(), key=lambda x: x[1], reverse=True)[:25])
