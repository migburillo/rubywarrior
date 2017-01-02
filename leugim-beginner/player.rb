class Player
  MIN_HP = 12

  def play_turn(warrior)
    if not warrior.feel.empty?
      warrior.attack!
    elsif warrior.health < MIN_HP
      warrior.rest!
    else
      warrior.walk!
    end
  end
end
