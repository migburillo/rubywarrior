class Player
  @direction

  def play_turn(warrior)
    @direction = warrior.direction_of_stairs

    if warrior.feel(@direction).empty?
      warrior.walk!(@direction)
    else
      warrior.attack!(@direction)
    end
  end
end