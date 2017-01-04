class Player
  MIN_HP = 16
  DIRECTIONS = [:left, :right, :forward, :backward]
  @last_health

  def play_turn(warrior)
    @last_health = 20 unless @last_health

    if not taking_damage?(warrior) and should_rest?(warrior)
      warrior.rest!
    elsif unit = get_ticking_in_room(warrior)
      if direction = captives_around?(warrior)
        warrior.rescue!(direction)
      else
        warrior.walk!(get_direction_to_unit(warrior, unit))
      end
    elsif direction = surrounded?(warrior)
      warrior.bind!(direction)
    elsif direction = enemy_around?(warrior)
      warrior.attack!(direction)
    elsif direction = captives_around?(warrior)
      warrior.rescue!(direction)
    elsif units = warrior.listen and units.count > 0
      warrior.walk!(get_direction_to_unit(warrior, units.first))
    elsif warrior.feel(warrior.direction_of_stairs).enemy?
      warrior.attack!(warrior.direction_of_stairs)
    else
      warrior.walk!(warrior.direction_of_stairs)
    end
    @last_health = warrior.health
  end

  def get_ticking_in_room(warrior)
    units = warrior.listen
    for unit in units
      if unit.ticking?
        return unit
      end
    end
    return false
  end

  def get_direction_to_unit(warrior, unit)
    direction = warrior.direction_of(unit)
    if warrior.feel(direction).stairs? or not warrior.feel(direction).empty?
      return get_alternative_direction(warrior, direction)
    else
      return direction
    end
  end

  def get_alternative_direction(warrior, direction)
    if direction == :left or direction == :right
      if warrior.feel(:forward).empty?
        return :forward
      end
        return :backward
    end
    if warrior.feel(:left).empty?
      return :left
    end
      return :right
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