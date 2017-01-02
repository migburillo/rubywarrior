class Player
  MIN_HP = 16
  RUN_HP = 10

  def play_turn(warrior)
    @last_health = 20 unless @last_health

    if warrior.feel.wall?
      warrior.pivot!
    elsif should_run_away?(warrior)
      warrior.walk!(:backward)
    elsif should_rest?(warrior)
      warrior.rest!
    elsif warrior.feel.captive?
      warrior.rescue!
    elsif warrior.feel.enemy?
      warrior.attack!
    elsif warrior.feel.empty?
      warrior.walk!
    end

    @last_health = warrior.health
  end

  def should_run_away?(warrior)
      return (warrior.health < RUN_HP and taking_damage?(warrior) and warrior.feel.empty?)
  end

  def should_rest?(warrior)
      return (warrior.health < MIN_HP and not taking_damage?(warrior))
  end

  def taking_damage?(warrior)
      return @last_health > warrior.health
  end

end
