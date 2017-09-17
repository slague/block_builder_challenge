# README

## Overview

The BlockBuilder is a command-line controller program for a robotic arm that takes commands that move blocks (a block is represented by an X) stacked in a series of slots. After each command, the state of the slots is printed to the terminal.  

### Commands:

`size [n]`
Adjusts the number of slots, resizing if necessary. When the arm is re-sized, blocks remain in place. However, if an arm is resized to a smaller size, blocks in the truncated space(s) are lost.

Example:
`size 3` builds an arm with two slots
```
1:
2:
3:
```


 * `add [slot]`
   Adds a block to the specified slot. Blocks are added one at a time. Blocks can only be added to slots that exist. If the spot does not exist, the user will be asked to provide a different slot.

   Example:
   `add 2` adds a block (X) to the second slot.
   ```
   1:
   2: X
   3:
   ```

 * `rm [slot]`
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

 * `mv [slot1] [slot2]`
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

 * `replay [n]`
   Replays the last n commands. Only successfully executed commands will be replayed. For example, if a user tries to move a block from a location that does not have a block. This command was not successful and so not counted. Replays begin with the most recently executed command and work backwards.

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


 * `undo [n]`
   Undo the last n commands. (NOTE: If a user enters `undo 2` and then follows with the command `undo 1`. The `undo 1` will effectively "undo" whatever the last action `undo 2` executed.)

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

 * `i` Displays this list of instructions.

 * `q` Ends the program.


### Setup
  1. Clone the repo
  2. Cd into the directory
  3. Run the program from the command line with `ruby lib/block_builder.rb`  


### Testing

This app uses minitest for testing. To run the tests:
1. Comment out the line of code outside of the BlockBuilder class in lib/block_builder.rb (The last line `BlockBuilder.start`)
2. Run `ruby test/block_builder_test.rb`
