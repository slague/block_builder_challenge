class BlockBuilder

  attr_accessor :arm

  def initialize(size)
    @arm = Array.new(size) { |i| "#{i+ 1}:" }
  end

  def display
    puts arm
  end

  # def instructions
  #
  # end

end


blocker = BlockBuilder.new(4)
blocker.display
