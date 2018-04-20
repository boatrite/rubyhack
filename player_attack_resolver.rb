class PlayerAttackResolver

  def self.resolve(prev_state, state)
    # If where the player moves...
    player_y = state[:player_position][:y]
    player_x = state[:player_position][:x]

    # Matches where the monster was... (since it could have moved, but not necessarily).
    monster_y = prev_state[:monster][:y]
    monster_x = prev_state[:monster][:x]

    # Then deduct monster hp. The player doesn't change squares if it lives.
    if player_y == monster_y && player_x == monster_x
      state[:monster_hp] -= 1
      state[:monster_hp] = [0, state[:monster_hp]].max
      if state[:monster_hp] == 0
      else
        state[:player_position][:y] = prev_state[:player_position][:y]
        state[:player_position][:x] = prev_state[:player_position][:x]
      end
    end
  end
end
