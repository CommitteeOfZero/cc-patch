import struct
import os
import sys

count = (0x556A * 2) + 2
input = open("wavtable_orig.dat", "rb")
output = open("wavtable.dat", "wb")
for i in range(0, count):
    num = struct.unpack(">H", input.read(2))[0]
    output.write(struct.pack("<H", num))
output.write(input.read())