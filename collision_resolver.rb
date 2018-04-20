class CollisionResolver

  def self.resolve(prev_state, state)
    entity_at_player_position = state[:room][state[:player_position][:y]][state[:player_position][:x]]
    case entity_at_player_position
    when H, V
      prev_state
    else
      state
    end
  end
end
