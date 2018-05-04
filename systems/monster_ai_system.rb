class MonsterAISystem < Recs::System

  def process_one_game_tick(prev_em, em)
    monster_entities = em.get_entities_with_tag Tag::MONSTER
    monster_entities.each do |entity|
      process_monster_ai prev_em, em, entity
    end
  end

  def process_monster_ai(prev_em, em, entity)
    prev_player_position = prev_em.get_component_of_type_from_tag Tag::PLAYER, Position
    monster_position = em.get_component_of_type entity, Position
    return if prev_player_position.node_id != monster_position.node_id

    player_health = em.get_component_of_type_from_tag Tag::PLAYER, Health
    monster_health = em.get_component_of_type entity, Health

    if prev_player_position.j.between?(monster_position.j-1, monster_position.j+1) && prev_player_position.i.between?(monster_position.i-1, monster_position.i+1)
      player_health.health -= 1
    end

    next_monster_i = monster_position.i + [-1, 0, 1].sample
    next_monster_j = monster_position.j + [-1, 0, 1].sample

    positions = em.get_components(Position)
      .select { |position| position.node_id == monster_position.node_id }

    destination_empty = positions.reduce(true) { |is_empty, position|
      if position.blocks?
        is_empty && (next_monster_i != position.i || next_monster_j != position.j)
      else
        is_empty
      end
    }

    if destination_empty
      monster_position.j = next_monster_j
      monster_position.i = next_monster_i
    end
  end
end
