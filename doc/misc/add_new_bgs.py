import csv
import sys
import os
import struct
import io

bg_mpk_ids = {}

existing = set()

cur_id = 0
with io.open('c0data_toc.csv', 'r') as f:
    reader = csv.reader(f)
    for row in reader:
        if row[0].startswith('#'):
            continue
        existing.add(row[2].lower())
        if int(row[0]) >= cur_id:
            cur_id = int(row[0]) + 1
        
all_bgs = set([f.lower() for f in os.listdir('cc-edited-images\\bg') if os.path.isfile(os.path.join('cc-edited-images\\bg', f))])
new_bgs = all_bgs.difference(existing)

def add_ids(f):
    f.seek(8, os.SEEK_SET)
    entries_count = struct.unpack('<Q', f.read(8))[0]
    for i in range(entries_count):
        f.seek(0x40 + (i * 0x100) + 4, os.SEEK_SET)
        entry_id = struct.unpack('<L', f.read(4))[0]
        f.seek(0x40 + (i * 0x100) + 0x20, os.SEEK_SET)
        entry_filename = f.read(0xE0).rstrip('\0').lower()
        bg_mpk_ids[entry_filename] = entry_id

with io.open('G:/Steam/SteamApps/common/CHAOS;CHILD/USRDIR/bg1.mpk', 'rb') as f:
    add_ids(f)

with io.open('G:/Steam/SteamApps/common/CHAOS;CHILD/USRDIR/bg2.mpk', 'rb') as f:
    add_ids(f)

consistency = []

with io.open('c0data_toc.csv', 'ab') as f:
    for bg in new_bgs:
        f.write("{0},{1},{2}\r\n".format(cur_id, os.path.join('cc-edited-images\\bg', bg), bg))
        #consistency
        original_name = bg.replace("-2.", ".")
        patchdef_line = "\"{0}\": {1},".format(bg_mpk_ids[original_name], cur_id)
        if original_name != bg:
            consistency.append(patchdef_line)
        else:
            print patchdef_line
        cur_id += 1

print ""
print ""
print "#consistency"
print ""
print ""

for line in consistency:
    print line