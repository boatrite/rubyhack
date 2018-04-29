class MonsterAISystem < Recs::System

  def process_one_game_tick(prev_em, em)
    prev_player_position = prev_em.get_component_of_type_from_tag Tag::PLAYER, Position
    last_player_y = prev_player_position.y
    last_player_x = prev_player_position.x

    prev_monster_position = prev_em.get_component_of_type_from_tag Tag::MONSTER, Position
    prev_monster_y = prev_monster_position.y
    prev_monster_x = prev_monster_position.x

    monster_health = em.get_component_of_type_from_tag Tag::MONSTER, Health
    player_health = em.get_component_of_type_from_tag Tag::PLAYER, Health

    if monster_health.health.nonzero?
      if last_player_x.between?(prev_monster_x-1, prev_monster_x+1) && last_player_y.between?(prev_monster_y-1, prev_monster_y+1)
        player_health.health -= 1
      end

      room_component = em.get_simple Tag::ROOM

      next_monster_y = prev_monster_y + [-1, 0, 1].sample
      next_monster_x = prev_monster_x + [-1, 0, 1].sample

      player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
      player_y = player_position.y
      player_x = player_position.x

      monster_position = em.get_component_of_type_from_tag Tag::MONSTER, Position

      # If monster destination is not a wall or the player, move it there.
      if ![H, V].include?(room_component.room[next_monster_y][next_monster_x]) && !(next_monster_y == player_y && next_monster_x == player_x)
        monster_position.x = next_monster_x
        monster_position.y = next_monster_y
      end
    end
  end
end
