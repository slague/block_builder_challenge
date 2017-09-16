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
#For this method I'm assuming that when the arm is re-sized, blocks remain in place.
#However, if an arm is resized to a smaller size, blocks in the truncated space(s) are lost.
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

  def add(input)
    if arm[input-1]
      arm[input-1] << " X"
      display
    else
      puts "The length of your arm is #{arm.length}. Select a number 1-#{arm.length}."
      add(gets.strip.to_i)
      # Note: The choice I made here is if a user inputs an unuseable number, the method is called again until a useable number is entered.
    end
  end

  def rm(input)
    if arm[input-1].nil?
      puts "The length of your arm is #{arm.length}. Select a number 1-#{arm.length}."
      rm(gets.strip.to_i)
      # Note: similar to the 'add' method, if a user inputs a space that does not exist, the method is called again until a space that exists on the arm is entered. If the space exists, but is empty see below.
    elsif arm[input-1].include?("X")
      arm[input-1] = arm[input-1].chomp(" X")
      display
    else
      puts "There are no blocks to remove. '#{arm[input-1]}' is empty."
      # Note: if the space exists but is empty, the 'rm' method does not get called again.
    end
  end

  def mv(input1, input2)
    if arm[input1-1].nil? || arm[input2-1].nil?
      puts "The arm is only #{arm.length} spaces long.\nYou cannot move blocks to spaces that do not exist. You can change the length of the arm with the command 'size [n]'."
    elsif arm[input1-1].include?("X") && arm[input2-1]
      arm[input1-1] = arm[input1-1].chomp(" X")
      arm[input2-1] <<" X"
      display
    else
      puts "There are no blocks in space '#{arm[input1-1]}' to move."
    end
  end

  def run_program
    input = gets.strip.split
    input[0] = input[0].downcase
    case input[0]
    when "size" then size(input[1].to_i)
    when "add" then add(input[1].to_i)
    when "rm" then rm(input[1].to_i)
    when "mv" then mv(input[1].to_i, input[2].to_i)
      # when "replay" then replay
      # when "undo" then undo
    when "i" then instructions
    when "q" then puts "Program ended."; exit
    end
    run_program
  end

end

# *------------------- *
puts "This is a controller program for a robotic arm that moves blocks stacked in a series of slots.
    \nTo begin, you will create your robotic arm. Enter a number to determine its size."

num = gets.chomp.to_i
blocker = BlockBuilder.new(num)
blocker.display
blocker.instructions
blocker.run_program
