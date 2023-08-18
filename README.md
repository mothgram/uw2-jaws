# uw2-jaws
Mr. Jaws patch for Origin/Looking Glass Studio's Ultima Underworld 2

This patch transforms every NPC in Ultima Underworld 2 into the iconic character "Mr. Jaws." Beyond the sublime joy you will experience, there is no other consequence. The change is only aesthetic, and the game can be played and completed as usual, albeit in a more toothy fashion.

![image](https://github.com/mothgram/uw2-jaws/assets/91193282/8a4a6c6e-1d4b-433d-8ced-aabaec8474c6)


### Installation and Use 

A pre-assembled JAWS.EXE can be found in the release section and in the repository. This is a 16-bit DOS executable and should be run in a DOS 2.0 or higher environment. (If you can run UW2.EXE, you can run JAWS.EXE.) The patch has been tested both on original hardware and in DOSBox.

To patch your game, just place JAWS.EXE inside the Ultima Underworld 2 folder (normally "UW2") and execute it.

The Mr. Jaws patch is permanent and offers no refunds, so you may wish to manually backup the "CRIT" folder before proceeding. If you want to be efficient, the only files modified are AS.AN, CR37.00, CR37.01, and CR37.02.

### Assembling from Source

The supplied JAWS.EXE was assembled with the OpenWatcom assembler (WASM) on a Windows 98 machine. If you have access to a DOS environment (including DOSBox) and have OpenWatcom installed, assembling and linking is trivial:
```
wasm jaws
wlink FILE jaws.obj NAME jaws
```
If you link on Linux, remember that WASM will produce an .o file by default, and that you will need to supply the linker with a system directive:
```
wlink FILE jaws.o NAME jaws SYSTEM dos
```
### How It Works

The patch modifies the AS.AN, CR37.00, CR37.01, and CR37.02 files.

AS.AN is a table used as reference for critter animations and palettes. The Mr. Jaws patch simply replaces every entry with a reference to the animation sheet that contains Mr. Jaws. Each palette index is also modified to ensure Mr. Jaws appears correctly.

CR37.00 holds frame and image data for several irregular critters - the floating fish, the vortex, the skull, the hellhound, and Mr. Jaws. Because we only care about Mr. Jaws, the patch modifies the header of this file to point all the offsets towards his animation frames. This is necessary not only for a 100% Mr. Jaws experience, but because the other sprites would otherwise be used as frame data by regular enemies, causing them to morph into hellhounds, vortexes, etc. We cannot allow this, because we have no interest in seeing any sprite other than Mr. Jaws.

CR37.01 and CR37.02 hold additional frame and image data for certain special animations (for example, casting spells.) Unfortunately, these files do not contain any frame data for Mr. Jaws! To fix this, the patch takes the compressed image data from CR37.00, inserts that data into these files, and redirects the offsets.
