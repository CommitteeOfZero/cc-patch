# How we fixed the voice issues

**Note: This page is purely for informative purposes. For building the patch yourself, you can just use the results as configured.**

Naively putting the English Vita scripts into the Japanese PC version causes lipsync issues, missing and mismatched audio since the translation split up some dialogue lines:

E.g. Japanese `voice.mpk`:

| Archive file ID | Description  |
|-----------------|--------------|
| 1               | Voice line 1 |
| 2               | Voice line 2 |
| 3               | Voice line 3 |
| 4               | Voice line 4 |
| 5               | Voice line 5 |

became English `voice.mpk`:

| Archive file ID | Description                   |
|-----------------|-------------------------------|
| 1               | Voice line 1                  |
| 2               | Voice line 2                  |
| **3**           | **Voice line 3, first half**  |
| **4**           | **Voice line 3, second half** |
| **5**           | **Voice line 4**              |

While the Steam version ships the modified audio data, they forgot to port over the modified lipsync data. Also, the original Steam version's native code expects big-endian lipsync data (like some console builds and unlike the Japanese PC version or later updates).

### Missing/mismatched audio

Here's how we fixed that for Vita->PC:

- Dump a list of all files in English Vita `voice.mpk` but not in Japanese `voice.mpk` to `envita_additions.txt`
- Convert the files to Ogg Vorbis
- Put the added files into `c0data.mpk` (starting at ID 19, that's what we were at)
- Splice the added lines into the voice archive ID space (e.g. redirecting voice/3 to c0data/19, voice/4 to c0data/20, voice/5 to voice/4 etc.) with a LanguageBarrier file redirection config generated by `generate_voice_json.rb`

### Lipsync

Lipsync data is stored in `wavtable.dat` in `system.mpk`. One would think you could just copy this file from the English Vita version to the PC version, but no.
For some reason, a field in the structure contained by this file is stored in big-endian on Vita, but little-endian on PC (despite both x86 and ARM being little-endian architectures). `wavtable_endian_swap.py` converts English Vita `wavtable_orig.dat` into a `wavtable.dat` suitable for use in the PC release.

The offset to the array of data in need of endian-swapping is hardcoded in the script, but it's the very first field in the file anyway.