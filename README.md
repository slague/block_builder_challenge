# README

## Overview

The BlockBuilder is a command-line controller program for a robotic arm that takes commands that move blocks (a block is represented by an X) stacked in a series of slots. After each command, the state of the slots is printed to the terminal.  

### Setup
1. Clone the repo
2. Cd into the directory
3. Run the program from the command line with `ruby lib/block_builder.rb`  
4. Follow the instructions that appear on the screen to begin.
5. Enter commands as you choose. See options below.

### Testing

This app uses minitest for testing. To run the tests:
1. In lib/block_builder.rb, comment out `BlockBuilder.start` at the very bottom of the file. 
2. Run `ruby test/block_builder_test.rb`

### Commands:

`size [n]`
Adjusts the number of slots, resizing if necessary. When the arm is resized, blocks remain in place. However, if an arm is resized to a smaller size, blocks in the truncated space(s) are lost.

Example:
`size 3` rebuilds an arm with three slots which will look like this in the terminal:
```
1:
2:
3:
```
`add [slot]`
Adds a block to the specified slot. Blocks are added one at a time. Blocks can only be added to slots that exist. If the spot does not exist, the user will be asked to provide a different slot.

Example:
`add 2` adds a block (X) to the second slot.
```
1:
2: X
3:
```

`rm [slot]`
Removes a block from the slot. Blocks are removed one at a time. Blocks can only be removed from slots that currently have a block(s).

Example:
`rm 2` removes the block from the second slot.
```
1:
2: X
3:
```
becomes
```
1:
2:
3:
```

`mv [slot1] [slot2]`
Moves a block from slot1 to slot2. Blocks are moved one at a time. Blocks cannot be moved to spaces that do not exist.

Example:
`mv 2 1` moves the block in the second slot to the first.
```
1:
2: X
3:
```
becomes
```
1: X
2:
3:
```

`replay [n]`
Replays the last n commands. Only successfully executed commands will be replayed. For example, if a user tries to move a block from a location that does not have a block. This command was not successful and so not counted. Replays begin with the most recently executed command and work backwards. If no number [n] is given, the last command entered is replayed.

Example:
`replay 2` Gives the last two commands and replays them.
```
add, 1
mv 1, 2
```
becomes
```
1:
2: X
3:
```

`undo [n]`
Undo the last n commands. If no number [n] is given, the last command entered is undone. (NOTE: If a user enters `undo 2` and then follows with the command `undo 1`. The `undo 1` will effectively "undo" whatever the last action `undo 2` executed.)

Example:
`undo 2` Gives the last two commands and undoes them.
```
rm 1
rm 1
```
becomes
```
1: X X
2:
3:
```

`+add [slot]`
Adds a block to the specified slot. If the spot does not exist, it resizes the arm and adds the block. This counts as one command. When it is replayed or undone, both the add and resize are replayed/undone together.

Example:
`+add 4` resizes the arm and adds a block.
```
1:
2: X
3:
```
becomes
```
1:
2: X
3:
4: X
```

`+mv [slot1] [slot2]`
Moves a block to the specified slot. If the spot does not exist, it resizes the arm and moves the block. This counts as one command. When it is replayed or undone, both the move and resize are replayed/undone together. Note: If there is not a block in [slot1] the arm will still be resized to create [slot2], however, no blocks will be moved.

Example:
`+mv 2, 4` resizes the arm and moves a block.
```
1:
2: X
3:
```
becomes
```
1:
2:
3:
4: X
```

`i` Displays this list of instructions.

`q` Ends the program.
