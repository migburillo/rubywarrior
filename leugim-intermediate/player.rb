class Player
  MIN_HP = 14
  DIRECTIONS = [:left, :right, :forward, :backward]
  @last_health

  def play_turn(warrior)
    @last_health = 20 unless @last_health

    if not taking_damage?(warrior) and should_rest?(warrior)
      warrior.rest!
    elsif direction = surrounded?(warrior)
      warrior.bind!(direction)
    elsif direction = enemy_around?(warrior)
      warrior.attack!(direction)
    elsif direction = captives_around?(warrior)
      warrior.rescue!(direction)
    elsif units = warrior.listen and units.count > 0
      warrior.walk!(warrior.direction_of(units.first))
    elsif warrior.feel(warrior.direction_of_stairs).enemy?
      warrior.attack!(warrior.direction_of_stairs)
    else
      warrior.walk!(warrior.direction_of_stairs)
    end
    @last_health = warrior.health
  end

  def surrounded?(warrior)
    enemies_count = 0
    for direction in DIRECTIONS
      if warrior.feel(direction).enemy?
        enemies_count = enemies_count + 1
      end
      if enemies_count > 1
        return direction
      end
    end
    return false
  end

  def enemy_around?(warrior)
    for direction in DIRECTIONS
      if warrior.feel(direction).enemy?
         return direction
      end
    end
    return false
  end

  def captives_around?(warrior)
    for direction in DIRECTIONS
      if warrior.feel(direction).captive?
        return direction
      end
    end
    return false
  end

  def taking_damage?(warrior)
      return @last_health > warrior.health
  end

  def should_rest?(warrior)
      return warrior.health < MIN_HP
  end

end