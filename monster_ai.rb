class MonsterAI

  def self.resolve(prev_state, state, em)
    last_player_y = prev_state[:player_position][:y]
    last_player_x = prev_state[:player_position][:x]

    monster_y = prev_state[:monster][:y]
    monster_x = prev_state[:monster][:x]

    if state[:monster_hp].nonzero?
      if last_player_x.between?(monster_x-1, monster_x+1) && last_player_y.between?(monster_y-1, monster_y+1)
        state[:player_hp] -= 1
      end

      room_entity = em.get_entity_with_tag Tag::ROOM
      room_component = em.get_component_of_type room_entity, Room

      next_monster_y = monster_y + [-1, 0, 1].sample
      next_monster_x = monster_x + [-1, 0, 1].sample
      player_y = state[:player_position][:y]
      player_x = state[:player_position][:x]
      if ![H, V].include?(room_component.room[next_monster_y][next_monster_x]) && !(next_monster_y == player_y && next_monster_x == player_x)
        room_component.room[state[:monster][:y]][state[:monster][:x]] = E
        state[:monster][:x] = next_monster_x
        state[:monster][:y] = next_monster_y
        room_component.room[state[:monster][:y]][state[:monster][:x]] = M
      end
    end
  end
end
