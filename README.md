# cc-port

Original English v1.01 scripts (binary, extracted) are expected in `script_archive_v101`.

Other dependencies:

- VS2015
- Qt 5.9+ for VS2015
- Libraries for noidget (see conf.pri.sample)

# Snapshotting this repo for public source release

- Clone repo (for clean gitignore snapshot)
- Clear .git
- Reinitialise submodules (TODO how?)
- Remove `cc-scripts` and `cc-scripts-consistency` submodules, .gitkeep the empty folders
- Remove contents of `cc-edited-images`, `content/languagebarrier/audio`, `content/languagebarrier/video`, `script_archive_v101` (TODO `script_archive_steam`), .gitkeep empty folders
- Probably remove `add_new_bgs.py`, it's kinda specific to our workflow
