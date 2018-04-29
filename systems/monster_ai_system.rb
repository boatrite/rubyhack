class MonsterAISystem < Recs::System

  def process_one_game_tick(prev_em, em)
    monster_entities = em.get_entities_with_tag Tag::MONSTER
    monster_entities.each do |entity|
      process_monster_ai prev_em, em, entity
    end
  end

  def process_monster_ai(prev_em, em, entity)
    prev_player_position = prev_em.get_component_of_type_from_tag Tag::PLAYER, Position
    last_player_i = prev_player_position.i
    last_player_j = prev_player_position.j

    monster_position = em.get_component_of_type entity, Position
    monster_i = monster_position.i
    monster_j = monster_position.j

    player_health = em.get_component_of_type_from_tag Tag::PLAYER, Health
    monster_health = em.get_component_of_type entity, Health

    if last_player_j.between?(monster_position.j-1, monster_position.j+1) && last_player_i.between?(monster_position.i-1, monster_position.i+1)
      player_health.health -= 1
    end

    next_monster_i = monster_position.i + [-1, 0, 1].sample
    next_monster_j = monster_position.j + [-1, 0, 1].sample

    position_entities = em.get_entities_with_component_of_type Position
    destination_empty = position_entities.reduce(true) { |is_empty, entity|
      position = em.get_component_of_type entity, Position
      is_empty && (next_monster_i != position.i || next_monster_j != position.j)
    }

    # If monster destination is not a wall or something else, move it there.
    room_component = em.get_simple Tag::ROOM
    if ![H, V].include?(room_component.room[next_monster_i][next_monster_j]) && destination_empty
      monster_position.j = next_monster_j
      monster_position.i = next_monster_i
    end
  end
end
