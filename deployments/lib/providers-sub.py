import os, sys, re

r = re.compile(r'\${var.([^}]*)}')
for line in sys.stdin:
    def sub(mo):
        name = mo.group(1)
        return os.environ['TF_VAR_' + name]
    sys.stdout.write(r.sub(sub, line))

