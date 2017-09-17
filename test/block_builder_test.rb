require 'minitest/autorun'
require_relative '../lib/block_builder'
require 'minitest/pride'

def puts(*args) end #silences puts statements

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

  def test_replay
    blocker = BlockBuilder.new(3)
    blocker.add(2)
    blocker.add(2)
    blocker.replay(2)
    assert_equal ["1:", "2: X X X X", "3:"], blocker.arm
  end

  def test_undo
    blocker = BlockBuilder.new(3)
    blocker.add(2)
    blocker.mv(2, 1)
    blocker.add(3)
    blocker.undo(2)
    assert_equal ["1:", "2: X", "3:"], blocker.arm
  end

  def test_build_and_add
    blocker = BlockBuilder.new(3)
    blocker.build_and_add(4)
    assert_equal ["1:", "2:", "3:", "4: X"], blocker.arm
    blocker.build_and_add(5)
    assert_equal ["1:", "2:", "3:", "4: X", "5: X"], blocker.arm
  end

  def test_build_and_mv
    blocker = BlockBuilder.new(3)
    blocker.add(2)
    blocker.build_and_mv(2, 4)
    assert_equal ["1:", "2:", "3:", "4: X"], blocker.arm
  end

end
