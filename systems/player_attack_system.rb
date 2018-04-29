class PlayerAttackSystem < Recs::System

  def process_one_game_tick(prev_em, em)
    # If where the player moves...
    player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
    player_y = player_position.y
    player_x = player_position.x

    # Matches where the monster was... (since it could have moved, but not necessarily).
    monster_position = prev_em.get_component_of_type_from_tag Tag::MONSTER, Position
    monster_y = monster_position.y
    monster_x = monster_position.x

    # Then deduct monster hp. The player doesn't change squares if it lives.
    if player_y == monster_y && player_x == monster_x
      monster_health = em.get_component_of_type_from_tag Tag::MONSTER, Health
      monster_health.health -= 1
      monster_health.health = [0, monster_health.health].max
      unless monster_health.health == 0
        prev_player_position = prev_em.get_component_of_type_from_tag Tag::PLAYER, Position
        player_position.y = prev_player_position.y
        player_position.x = prev_player_position.x
      end
    end
  end
end
