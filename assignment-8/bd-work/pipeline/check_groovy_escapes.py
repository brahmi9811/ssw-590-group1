import re, sys
VALID = set("btnfr\"'\$01234567u\n\r")
bad = 0
for name in sys.argv[1:]:
    s = open(name, encoding="utf-8").read()
    for m in re.finditer(r"'''(.*?)'''", s, re.S):
        body = m.group(1)
        line0 = s[:m.start()].count("\n") + 1
        i = 0
        while i < len(body):
            if body[i] == "\\":
                nxt = body[i + 1] if i + 1 < len(body) else ""
                if nxt not in VALID:
                    ln = line0 + body[:i].count("\n")
                    print("%s line %d: invalid Groovy escape \%s" % (name, ln, nxt)); bad += 1
                i += 2
            else:
                i += 1
print("invalid escapes:", bad)
sys.exit(1 if bad else 0)
