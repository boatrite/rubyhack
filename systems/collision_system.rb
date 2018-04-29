class CollisionSystem < Recs::System

  def process_one_game_tick(prev_em, em)
    room_component = em.get_simple Tag::ROOM

    player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
    entity_at_player_position = room_component.room[player_position.i][player_position.j]
    case entity_at_player_position
    when H, V
      prev_em
    else
      em
    end
  end
end
