class MonsterAISystem < Recs::System

  def process_one_game_tick(prev_em, em)
    monster_entities = em.get_entities_with_tag Tag::MONSTER
    monster_entities.each do |entity|
      process_monster_ai prev_em, em, entity
    end
  end

  def process_monster_ai(prev_em, em, entity)
    prev_player_position = prev_em.get_component_of_type_from_tag Tag::PLAYER, Position
    last_player_y = prev_player_position.y
    last_player_x = prev_player_position.x

    monster_position = em.get_component_of_type entity, Position
    monster_y = monster_position.y
    monster_x = monster_position.x

    player_health = em.get_component_of_type_from_tag Tag::PLAYER, Health
    monster_health = em.get_component_of_type entity, Health

    if last_player_x.between?(monster_position.x-1, monster_position.x+1) && last_player_y.between?(monster_position.y-1, monster_position.y+1)
      player_health.health -= 1
    end

    room_component = em.get_simple Tag::ROOM

    next_monster_y = monster_position.y + [-1, 0, 1].sample
    next_monster_x = monster_position.x + [-1, 0, 1].sample

    position_entities = em.get_entities_with_component_of_type Position
    destination_empty = position_entities.reduce(true) { |is_empty, entity|
      position = em.get_component_of_type entity, Position
      is_empty && (next_monster_y != position.y || next_monster_x != position.x)
    }

    # If monster destination is not a wall or something else, move it there.
    if ![H, V].include?(room_component.room[next_monster_y][next_monster_x]) && destination_empty
      monster_position.x = next_monster_x
      monster_position.y = next_monster_y
    end
  end
end
