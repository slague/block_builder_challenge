module Messages

#I've pulled out the messages to dry up the block_builder file and to easily reuse messages.
  def print_instructions
    puts "You can use the following commands to add, change, and remove blocks.\n
    size [n]   - Adjusts the number of slots, resizing if necessary.
    add [slot] - Adds a block to the specified slot.
    +add [slot] - Extends the arm to the specified slot and adds a block to it.
    mv [slot1] [slot2] - Moves a block from slot1 to slot2.
    +mv [slot1] [slot2] - Extends the arm to slot2 and moves a block from slot1 to slot2.
    rm [slot]  - Removes a block from the slot.
    replay [n] - Replays the last n commands.
    undo [n]   - Undo the last n commands.
    i  to repeat these instructions.
    q to quit the program."
  end

  def size_reminder(arm)
    puts "The length of your arm is #{arm.length}. Enter a number 1-#{arm.length}. NOTE: Do not re-enter the command."
  end

  def slot_is_empty_reminder(input)
    puts "There are no blocks here. Slot '#{arm[input-1]}' is empty."
  end

  def can_only_move_blocks_to_existing_slots_reminder(arm)
    puts "The arm is only #{arm.length} spaces long.\nYou cannot move blocks to spaces that do not exist. You can use +mv to resize the arm and move blocks in one command."
  end

  def last_commands_reminder(input)
    puts "The last #{input} commands were:"
  end

  def invalid_entry_alert
    puts "Invalid entry. Try again. Press i to see the list of commands."
  end

end
