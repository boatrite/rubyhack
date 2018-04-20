class MonsterAI

  def self.resolve(room, prev_state, state)
    player_y = prev_state[:player_position][:y]
    player_x = prev_state[:player_position][:x]

    monster_y = prev_state[:monster][:y]
    monster_x = prev_state[:monster][:x]

    if player_x.between?(monster_x-1, monster_x+1) && player_y.between?(monster_y-1, monster_y+1)
      state[:player_hp] -= 1
    end
  end
end
