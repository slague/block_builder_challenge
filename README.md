# README

## Overview

The BlockBuilder is a command-line controller program for a robotic arm that takes commands that move blocks (a block is represented by an X) stacked in a series of slots. After each command, the state of the slots is printed to the terminal.  

### Commands:

 * size [n] - Adjusts the number of slots, resizing if necessary. When the arm is re-sized, blocks remain in place. However, if an arm is resized to a smaller size, blocks in the truncated space(s) are lost.
 * add [slot] - Adds a block to the specified slot. Blocks are added one at a time. Blocks can only be added to slots that exist. If the spot does not exist, the user will be asked to provide a different slot.
 * rm [slot] - Removes a block from the slot. Blocks are removed one at a time. Blocks can only be removed from slots that currently have a block(s).
 * mv [slot1] [slot2] - Moves a block from slot1 to slot2. Blocks are moved one at a time. Blocks cannot be moved to spaces that do not exist.
 * replay [n] - Replays the last n commands.
 * undo [n] - Undo the last n commands.
 * i - Displays this list of instructions.
 * q - Ends the program.


### Testing

This app uses minitest for testing. To run the tests:
1. Comment out the lines of code outside of the BlockBuilder class in lib/block_builder.rb (This is everything below the comment line.)
2. Run `ruby test/block_builder_test.rb`
