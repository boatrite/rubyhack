class PlayerAttackSystem < Recs::System

  def process_one_game_tick(prev_em, em)
    # If where the player moves...
    player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position

    monster_entities = em.get_entities_with_tag Tag::MONSTER
    monster_entities.each do |entity|
      process_attacking_monster prev_em, em, entity, player_position
    end
  end

  private

  def process_attacking_monster(prev_em, em, entity, player_position)
    # Matches where the monster is... (since it could have moved, but not necessarily).
    #
    # Since PlayerAttackSystem runs before MonsterAISystem, the monsters haven't moved yet.
    # That's why we get monster position from em instead of prev_em.
    monster_position = em.get_component_of_type entity, Position

    # Then deduct monster hp. The player doesn't change squares if it lives.
    if player_position.y == monster_position.y && player_position.x == monster_position.x
      monster_health = em.get_component_of_type entity, Health
      monster_health.health -= 1

      if monster_health.health <= 0
        em.kill_entity entity
      else
        prev_player_position = prev_em.get_component_of_type_from_tag Tag::PLAYER, Position
        player_position.y = prev_player_position.y
        player_position.x = prev_player_position.x
      end
    end
  end
end
