class CollisionResolver

  def self.resolve(prev_state, prev_em, state, em)
    room_component = em.get_simple Tag::ROOM

    entity_at_player_position = room_component.room[state[:player_position][:y]][state[:player_position][:x]]
    case entity_at_player_position
    when H, V
      [prev_state, prev_em]
    else
      [state, em]
    end
  end
end
