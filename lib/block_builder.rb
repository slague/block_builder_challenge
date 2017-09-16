class BlockBuilder

  attr_accessor :arm

  def initialize(size)
    @arm = Array.new(size) { |i| "#{i+ 1}:" }
  end

  def display
    puts arm
  end

  def instructions
    # I am assuming a user will first input the command followed by a number (or in the case of mv two numbers) and press enter. For i and q, no numbers follow. There must be a space between the command and number.
    puts "Now that you have built the robotic arm, you can use the following commands to add, change, and remove blocks:\n
    size [n] - Adjusts the number of slots, resizing if necessary.
    add [slot] - Adds a block to the specified slot.
    mv [slot1] [slot2] - Moves a block from slot1 to slot2.
    rm [slot] - Removes a block from the slot.
    replay [n] - Replays the last n commands.
    undo [n] - Undo the last n commands.
    i  to repeat these instructions.
    q to quit the program."
  end

  def size(input)
    current_arm = arm.length
    if input <= current_arm
      arm.pop(current_arm - input)
    else
      (input - current_arm).times do |i|
        arm <<  "#{current_arm + i + 1}:"
      end
    end
    display
  end


end

# puts "This is a controller program for a robotic arm that moves blocks stacked in a series of slots.
#     \nTo begin, you will create your robotic arm. Enter a number to determine its size."
#
# num = gets.chomp.to_i
# blocker = BlockBuilder.new(num)
# blocker.display
# blocker.instructions
#
# input = gets.strip.split
#
# case input[0]
# when "size" then blocker.size(input[1].to_i)
#   # when "add" then blocker.add
#   # when "mv" then mv
#   # when "rm" then rm
#   # when "replay" then replay
#   # when "undo" then undo
#   when "i" then instructions
#   when "q" then puts "Program ended."; exit
# end
