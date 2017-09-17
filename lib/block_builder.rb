require_relative 'messages'

class BlockBuilder
  include Messages
  attr_accessor :arm, :commands

  def initialize(size)
    @arm = Array.new(size) { |i| "#{i+ 1}:" }
    @commands = []
  end

  def display
    puts arm
  end

  def instructions
    # There must be a space between the command and number(s) that follow.
    # The number may be within brackets or not; either way will work.
    # For i and q, no numbers follow. I included these two commands to allow the user to quit the program and to check the instructions when needed.
    print_instructions
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
    if arm[input-1] && input !=0
      arm[input-1] << " X"
      commands << ["add", input]
      display
    else
      size_reminder(arm)
      add(gets.strip.delete('[]').to_i)
      # If a user inputs a slot that does not exist number, the method is called again until a useable number is entered. **Only a number (with or without brackets) needs to be entered here!
    end
  end

  def build_and_add(input)
    size(input)
    add(input)
    commands.pop
    commands[-1][0] = "+add"
    # This is a method I added so that if a user wants to add a block to a slot that has not been created, they can do both in the same command
  end

  def rm(input)
    if arm[input-1].nil? || input == 0
      size_reminder(arm)
      rm(gets.strip.delete('[]').to_i)
      # Similar to the 'add' method, if a user inputs a space that does not exist, the method is called again until a space that exists on the arm is entered. **Only a number (with or without brackets) needs to be entered here! If the space exists, but is empty see below.
    elsif arm[input-1].include?("X")
      arm[input-1] = arm[input-1].chomp(" X")
      commands << ["rm", input]
      display
    else
      slot_is_empty_reminder(input)
      # If the space exists but is empty, the 'rm' method does not get called again.
    end
  end

  def mv(input1, input2)
    if arm[input1-1].nil? || arm[input2-1].nil? || input2 == 0
      can_only_move_blocks_to_existing_slots_reminder(arm)
    elsif arm[input1-1].include?("X") && arm[input2-1]
      arm[input1-1] = arm[input1-1].chomp(" X")
      arm[input2-1] <<" X"
      commands << ["mv", input1, input2]
      display
    else
      slot_is_empty_reminder(input1)
    end
  end

  def build_and_mv(input1, input2)
    size(input2)
    if arm[input1-1].include?("X")
      mv(input1, input2)
      commands[-1], commands[-2] = commands[-2], commands[-1]
      commands[-2] << commands[-1][-1]
      commands.pop
      commands[-1][0] = "+mv"
    else
      mv(input1, input2)
    end
      # This is a method I added so that if a user wants to move a block to a slot that has not been created, they can do both in the same command.
      #If there is not a block in [slot1] the arm will still be resized to create [slot2], however, no blocks will be moved. And a message will be given to the user. Because the resize is a successfully executed command it is save, but the move is not.
  end

  def replay(input)
    #I chose to only count successfully executed commands. For example, if a user tries to move a block from a location that does not have a block. This command was not successful and so not counted.
    #Replays occur in order starting with the most recently executed and working backwards.
    replays = commands.reverse.take(input)
    last_commands_reminder(input)
    replays.each { |replay| puts "#{replay}"}
    puts "I will replay them now."
    sleep(1)
    replays.each do |replay|
      sleep(1)
      execute_commands(replay)
    end
    # If a number is not entered with this command, the program assumes 1 and replays the last command
    # I am not adding "replay" to the commands array.  I have chosen to do this so that if a user selects replay and then replay again they do not get stuck in a loop.
  end

  def undo(input=1)
    undos = commands.reverse.take(input)
    last_commands_reminder(input)
    undos.each { |undo| puts "#{undo}"}
    puts "I will undo them now."
    sleep(1)
    undos.each do |undo|
      case undo[0]
        when "size" then size(undo[2][-1].to_i)
        when "add" then rm(undo[1])
        when "+add"  then size(undo[2][-1].to_i)
        when "mv" then mv(undo[2].to_i, undo[1])
        when "+mv" then mv(undo[2], undo[1]); size(undo[-1][-1].to_i)
        when "rm" then add(undo[1])
        when "undo" then undo(undo[1])
      end
    # If a number is not entered with this command, the program assumes 1 and undoes the last command
    # I am not adding "undo" to the commands array.  This way, for example, if a user enters `undo 2` and then follows with the command `undo 1`. The `undo 1` will effectively "undo" whatever the last action `undo 2` executed.
    end
  end

  def execute_commands(arr)
    case arr[0]
      when "size" then size(arr[1].to_i)
      when "add" then add(arr[1].to_i)
      when "+add" then build_and_add(arr[1].to_i)
      when "mv" then mv(arr[1].to_i, arr[2].to_i)
      when "+mv" then build_and_mv(arr[1].to_i, arr[2].to_i)
      when "rm" then rm(arr[1].to_i)
      when "replay" then replay(arr[1].to_i)
      when "undo" then undo(arr[1].to_i)
      when "i" then instructions
      when "q" then puts "Program eneded."; exit
    end
  end

  def check_input(input)
    condition1 = input.length == 1 && %w(i q).include?(input[0])
    condition2 = input.length ==2 && %w(size add rm replay undo +add).include?(input[0]) && input[1].to_i > 0
    condition3 = input.length == 3 && %w(mv +mv).include?(input[0]) && input[1].to_i > 0 && input[2].to_i > 0
    condition4 = input.length == 1 && %w(replay undo).include?(input[0]) && input[1].nil?

    unless condition1 || condition2 || condition3 || condition4
      invalid_entry_alert
      run_program
    end
    input[1] = "1" if condition4
  end

  def clean_input(input)
    input[0] = input[0].downcase
    input[1] = input[1].delete('[]') if input[1]
    input[2] = input[2].delete('[]') if input[2]
  end

  def run_program
    input = gets.strip.split
    clean_input(input)
    check_input(input)
    execute_commands(input)
    run_program
  end

  def self.start
    puts "This is a program for a robotic arm that moves blocks stacked in a series of slots.\nTo begin, create the robotic arm. Enter a number to determine its size."
    num = gets.chomp.to_i
    if num == 0
      puts "You must enter a number. Starting over..."
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
