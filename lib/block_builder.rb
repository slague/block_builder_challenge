class BlockBuilder

  attr_accessor :arm, :commands

  def initialize(size)
    @arm = Array.new(size) { |i| "#{i+ 1}:" }
    @commands = []
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
    commands << ["i"]
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
    commands << ["size", input, "resized from #{current_arm}"]
    display
  end

  def add(input)
    if arm[input-1]
      arm[input-1] << " X"
      commands << ["add", input]
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
      commands << ["rm", input]
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
      commands << ["mv", input1, input2]
      display
    else
      puts "There are no blocks in space '#{arm[input1-1]}' to move."
    end
  end

  def replay(input)
  #Note: I chose to only count successfully executed commands. For example if a user tries to move a block from a location that does not have a block. This command was not successful and so not counted.
  #I am also assuming the replays occur in order starting with the most recently executed and working backwards.
    replays = commands.reverse.take(input)
    puts "The last #{input} commands were:"
    replays.each { |replay| puts "#{replay}"}
    puts "I will replay them now."
    sleep(1)
    replays.each do |replay|
      sleep(1)
      execute_commands(replay)
    end
    # Note: I am not adding "replay" to the commands array.  I have chosen to do this so that if a user selects replay and then replay again they do not get stuck in a loop.
  end

  def undo(input)
    undos = commands.reverse.take(input)
    puts "The last #{input} commands were:"
    undos.each { |undo| puts "#{undo}"}
    puts "I will undo them now."
    sleep(1)
    undos.each do |undo|
      case undo[0]
        when "size" then size(undo[2][-1].to_i)
        when "add" then rm(undo[1])
        when "mv" then mv(undo[2].to_i, undo[1])
        when "rm" then add(undo[1])
        when "undo" then undo(undo[1])
      end
    # Note: I am not adding "undo" to the commands array.  This way, for example, if a user enters `undo 2` and then follows with the command `undo 1`. The `undo 1` will effectively "undo" whatever the last action `undo 2` executed.
    end
  end

  def execute_commands(arr)
    case arr[0]
      when "size" then size(arr[1].to_i)
      when "add" then add(arr[1].to_i)
      when "mv" then mv(arr[1].to_i, arr[2].to_i)
      when "rm" then rm(arr[1].to_i)
      when "replay" then replay(arr[1].to_i)
      when "undo" then undo(arr[1].to_i)
      when "i" then instructions
      when "q" then puts "Program eneded."; exit
    end
  end

  def check_input(input)
    condition1 = input.length >= 2 && %w(size add mv rm replay undo).include?(input[0])
    condition2 = input.length == 1 && %w(i q).include?(input[0])

    unless condition1 || condition2
      puts "Invalid entry. Try again. Press i to see the list of commands again."
      run_program
    end
  end

  def run_program
    input = gets.strip.split
    input[0] = input[0].downcase
    check_input(input)
    execute_commands(input)
    run_program
  end

  def self.start
    puts "This is a controller program for a robotic arm that moves blocks stacked in a series of slots.\nTo begin, you will create your robotic arm. Enter a number to determine its size."
    num = gets.chomp.to_i
    if num == 0
      puts "You must enter a number. Starting over."
      sleep(1)
      start
    else
      blocker = BlockBuilder.new(num)
      blocker.display
      blocker.instructions
      blocker.run_program
    end
  end
end

# *------------------- *
BlockBuilder.start
