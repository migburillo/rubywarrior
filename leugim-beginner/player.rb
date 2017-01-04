class Player
  MIN_HP = 14
  RUN_HP = 10
  @pivoted = false

  def play_turn(warrior)
    @last_health = 20 unless @last_health

    if warrior.feel.wall?
        warrior.pivot!
    elsif archer_backwards?(warrior)
      @pivoted = true
      warrior.pivot!
    elsif enemy_ahead?(warrior)
      warrior.shoot!
    elsif @pivoted
      @pivoted = false
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

  def archer_backwards?(warrior)
    for space in warrior.look(:backward)
      if space.empty?
        next
      elsif space.captive?
        return false
      elsif (space.enemy? and space.to_s == "Archer")
        return true
      else
        return false
      end
    end
    return false
  end

  def enemy_ahead?(warrior)
    for space in warrior.look
      if space.captive?
        return false
      elsif space.enemy?
        return true
      end
    end
    return false
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
