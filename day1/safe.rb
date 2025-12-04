class Safe
  attr_reader :current_position, :zeros

  def initialize
    @current_position = 50
    @numbers_right = (0..99).to_a.cycle
    @numbers_left = (0..99).to_a.reverse.cycle
    @zeros = 0
  end

  def move(direction, times_to_move)
    if direction == 'L'
      (99 - @current_position).times { @numbers_left.next }
      times_to_move.times do
        @numbers_left.next
        @zeros += 1 if @numbers_left.peek.zero?
      end
      @current_position = @numbers_left.peek
      @numbers_left.rewind
    else
      @current_position.times { @numbers_right.next }
      times_to_move.times do
        @numbers_right.next
        @zeros += 1 if @numbers_right.peek.zero?
      end
      @current_position = @numbers_right.peek
      @numbers_right.rewind
    end
  end
end
