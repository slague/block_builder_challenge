require 'minitest/autorun'
require_relative '../lib/block_builder'
require 'minitest/pride'


class BlockBuilderTest < Minitest::Test

  def test_block_maker_is_valid
    blocker = BlockBuilder.new(3)
    assert_instance_of BlockBuilder, blocker
    assert_equal 3, blocker.arm.length
    assert_equal ["1:", "2:", "3:"], blocker.arm
  end


  def test_size

  end

  # def test_add
  #
  # end
  #
  # def test_mv
  #
  # end
  #
  # def test_rm
  #
  # end
  #
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
