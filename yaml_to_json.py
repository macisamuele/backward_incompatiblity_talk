import json
import sys

import yaml

if len(sys.argv) != 3:
    raise RuntimeError('Usage: {} <src_path> <dst_path>'.format(sys.argv[0]))


with open(sys.argv[1]) as fi, open(sys.argv[2], 'w') as fo:
    json.dump(yaml.load(fi, Loader=yaml.SafeLoader), fo, sort_keys=True, indent=4)
