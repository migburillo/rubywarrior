class Player
  MIN_HP = 16
  RUN_HP = 10

  def play_turn(warrior)
    @last_health = 20 unless @last_health
    @direction = :backward unless @direction

    if should_run_away?(warrior)
      warrior.walk!(:backward)
    elsif should_rest?(warrior)
      warrior.rest!
    elsif warrior.feel(@direction).captive?
      warrior.rescue!((@direction))
    elsif warrior.feel(@direction).enemy?
      warrior.attack!((@direction))
    elsif warrior.feel(@direction).wall?
      @direction = :forward
      warrior.walk!(@direction)
    elsif warrior.feel(@direction).empty?
      warrior.walk!(@direction)
    end

    @last_health = warrior.health
  end

  def should_run_away?(warrior)
      return (warrior.health < RUN_HP and taking_damage?(warrior))
  end

  def should_rest?(warrior)
      return (warrior.health < MIN_HP and not taking_damage?(warrior))
  end

  def taking_damage?(warrior)
      return @last_health > warrior.health
  end

end
