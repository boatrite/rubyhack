class CollisionSystem < Recs::System

  def process_one_game_tick(prev_em, em)
    node_component = em.get_simple Tag::NODE

    player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
    entity_at_player_position = node_component.map[player_position.i][player_position.j]
    case entity_at_player_position
    when H, V
      prev_em
    else
      em
    end
  end
end
