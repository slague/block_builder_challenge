require 'minitest/autorun'
require_relative '../lib/block_builder'
require 'minitest/pride'

def puts(*args) end #silences the 'puts statements'

class BlockBuilderTest < Minitest::Test

  def test_block_maker_is_valid
    blocker = BlockBuilder.new(3)
    assert_instance_of BlockBuilder, blocker
    assert_equal 3, blocker.arm.length
    assert_equal ["1:", "2:", "3:"], blocker.arm
  end


  def test_size
    blocker = BlockBuilder.new(3)
    blocker.size(4)
    assert_equal 4, blocker.arm.length
    assert_equal ["1:", "2:", "3:", "4:"], blocker.arm
  end

  def test_add
    blocker = BlockBuilder.new(3)
    blocker.add(2)
    assert_equal ["1:", "2: X", "3:"], blocker.arm
    blocker.add(2)
    assert_equal ["1:", "2: X X", "3:"], blocker.arm
  end



  def test_rm
    blocker = BlockBuilder.new(3)
    blocker.add(2)
    blocker.rm(2)
    assert_equal ["1:", "2:", "3:"], blocker.arm
  end

  def test_mv
    blocker = BlockBuilder.new(3)
    blocker.add(2)
    blocker.mv(2, 1)
    assert_equal ["1: X", "2:", "3:"], blocker.arm
  end


  # def test_replay
  #
  # end
  #
  # def test_undo

  # end
end
# Design a command-line controller program for a robotic arm that takes commands that move blocks stacked in a series of slots. After each command, output the state of the slots, which each line of output corresponding to a slot and each X corresponding to a block.
#
# Commands:
#
# size [n] - Adjusts the number of slots, resizing if necessary. Program must start with this to be valid.
# add [slot] - Adds a block to the specified slot.
# mv [slot1] [slot2] - Moves a block from slot1 to slot2.
# rm [slot] - Removes a block from the slot.
# replay [n] - Replays the last n commands.
# undo [n] - Undo the last n commands.
# Your program should validate that the commands are syntactically valid before executing them.
