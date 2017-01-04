class Player
  MIN_HP = 14
  DMG_BOMB = 4
  DIRECTIONS = [:forward, :backward, :left, :right]
  @last_health

  def play_turn(warrior)
    @last_health = 20 unless @last_health

    if direction = ticking_around?(warrior)
      warrior.rescue!(direction)
    elsif should_rest?(warrior)
      warrior.rest!
    elsif direction = surrounded?(warrior)
      warrior.bind!(direction)
    elsif direction = should_detonate?(warrior)
      warrior.detonate!(direction)
    elsif unit = get_ticking_in_room(warrior) and direction = get_direction_to_unit(warrior, unit)
      warrior.walk!(direction)
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

  def should_detonate?(warrior)
    if warrior.health <= DMG_BOMB
      return false
    end
    for direction in DIRECTIONS
      spaces = warrior.look(direction)
      if (spaces[0].enemy? or spaces[1].enemy?) and not ticking_near?(warrior)
         return direction
      end
    end
    return false
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
    if warrior.feel(direction).stairs?
      return get_alternative_direction(warrior, direction)
    elsif warrior.feel(direction).empty?
      return direction
    else
      return false
    end
  end

  def get_alternative_direction(warrior, direction)
    if direction == :left or direction == :right
      if warrior.feel(:forward).empty?
        return :forward
      elsif warrior.feel(:backward).empty?
        return :backward
      end
      return false
    end
    if warrior.feel(:left).empty?
      return :left
    elsif warrior.feel(:right).empty?
      return :right
    end
    return false
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

  def ticking_around?(warrior)
    for direction in DIRECTIONS
      if warrior.feel(direction).ticking?
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

  def ticking_near?(warrior)
    units = warrior.listen
    for unit in units
      if (unit.ticking? and warrior.distance_of(unit) <= 2)
        return true
      end
    end
    return false
  end

  def taking_damage?(warrior)
    return @last_health > warrior.health
  end

  def last_damage_received(warrior)
      return @last_health - warrior.health
  end

  def should_rest?(warrior)
    if warrior.listen.count == 0
      return false
    end
    if (not taking_damage?(warrior) or last_damage_received(warrior) == DMG_BOMB)
      return warrior.health < MIN_HP
    end
    return false
  end

end