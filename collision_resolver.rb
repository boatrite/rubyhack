class CollisionResolver

  def self.resolve(prev_state, prev_em, state, em)
    room_entity = em.get_entity_with_tag Tag::ROOM
    room_component = em.get_component_of_type room_entity, Room

    entity_at_player_position = room_component.room[state[:player_position][:y]][state[:player_position][:x]]
    case entity_at_player_position
    when H, V
      [prev_state, prev_em]
    else
      [state, em]
    end
  end
end
