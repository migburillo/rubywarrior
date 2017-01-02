class Player
  MIN_HP = 12

  def play_turn(warrior)
    @last_health = 20 unless @last_health

    if should_rest?(warrior)
      warrior.rest!
    elsif not warrior.feel.empty?
      warrior.attack!
    else
      warrior.walk!
    end

    @last_health = warrior.health
  end


  def should_rest?(warrior)
      return (warrior.health < MIN_HP and not taking_damage?(warrior))
  end

  def taking_damage?(warrior)
      return @last_health > warrior.health
  end

end
