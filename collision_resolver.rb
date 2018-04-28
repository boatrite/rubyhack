class CollisionResolver

  def self.resolve(prev_em, em)
    room_component = em.get_simple Tag::ROOM

    player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
    entity_at_player_position = room_component.room[player_position.y][player_position.x]
    case entity_at_player_position
    when H, V
      prev_em
    else
      em
    end
  end
end
