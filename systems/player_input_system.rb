class PlayerInputSystem < Recs::System

  def process_one_game_tick(em)
    puts 'Do what?'
    command = STDIN.getch
    case command
    when *%w(h j k l y u b n)
      player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
      next_player_i, next_player_j = player_position.i, player_position.j
      case command
      when 'h'
        next_player_j -= 1
      when 'j'
        next_player_i += 1
      when 'k'
        next_player_i -= 1
      when 'l'
        next_player_j += 1
      when 'y'
        next_player_i -= 1
        next_player_j -= 1
      when 'u'
        next_player_i -= 1
        next_player_j += 1
      when 'b'
        next_player_i += 1
        next_player_j -= 1
      when 'n'
        next_player_i += 1
        next_player_j += 1
      end

      # If the player is moving at an enemy, resolve attacking it. This removes
      # the entity if it is killed which will let the destination_empty check
      # pass for the spot the enemy had, so the player will move into that
      # spot.
      monster_entities = em.get_entities_with_tag Tag::MONSTER # TODO I feel like I'm going to have an Attackable component
      monster_entities.each do |entity|
        process_attacking_monster em, entity, next_player_i, next_player_j
      end

      # Figure out if there is something in the way of where the player is trying to move.
      position_entities = em.get_entities_with_component_of_type Position
      destination_empty = position_entities.reduce(true) { |is_empty, entity|
        position = em.get_component_of_type entity, Position
        if position.blocks?
          is_empty && (next_player_i != position.i || next_player_j != position.j)
        else
          is_empty
        end
      }

      if destination_empty
        player_position.i = next_player_i
        player_position.j = next_player_j
      end
    #when '<'
      #ascend_component = next_em.get_component_of_type_from_tag Tag::ASCEND, Edge
    when 'Q', 'q', 'exit'
      puts 'Bye!'
      exit
    end
  end

  private

  def process_attacking_monster(em, entity, next_player_i, next_player_j)
    # Matches where the monster is... (since it could have moved, but not necessarily).
    #
    # Since this system runs before MonsterAISystem, the monsters haven't moved yet.
    # That's why we get monster position from em instead of prev_em.
    monster_position = em.get_component_of_type entity, Position

    # Then deduct monster hp.
    if next_player_i == monster_position.i && next_player_j == monster_position.j
      monster_health = em.get_component_of_type entity, Health
      monster_health.health -= 1
      em.kill_entity entity if monster_health.health <= 0
    end
  end
end
