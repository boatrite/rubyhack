class PlayerInputSystem < Recs::System

  def process_one_game_tick(em)
    puts 'Do what?'
    command = STDIN.getch
    player_input_entities = em.get_entities_with_component_of_type PlayerInput
    player_inputs = player_input_entities.map { |entity| em.get_component_of_type entity, PlayerInput }
    player_inputs
      .select { |player_input| player_input.key == command && player_input.handler.valid?(em) }
      .each do |player_input|
        player_input.handler.fire em
      end
  end

  private

  class InputHandler
    attr_reader :context

    def initialize(context)
      @context = context
    end

    def valid?(em)
      true
    end
  end

  class DumpDetails < InputHandler
    def fire(em)
      File.write 'development.log', em.dump_details
    end
  end

  class SaveAndQuit < InputHandler
    def fire(em)
      File.write SAVEFILE, Marshal.dump(em)
      puts 'Bye!'
      exit
    end
  end

  class DoDirectionHandler < InputHandler
    private

    def process_movement(em, next_player_i, next_player_j)
      # If the player is moving at an enemy, resolve attacking it. This removes
      # the entity if it is killed which will let the destination_empty check
      # pass for the spot the enemy had, so the player will move into that
      # spot.
      monster_entities = em.get_entities_with_tag Tag::MONSTER # TODO I feel like I'm going to have an Attackable component
      monster_entities.each do |entity|
        process_attacking_monster em, entity, next_player_i, next_player_j
      end

      # Figure out if there is something in the way of where the player is trying to move.
      world = em.get_component World
      positions = em.get_components(Position)
        .select { |position| position.node_id == world.current_node_id }
      destination_empty = positions.reduce(true) { |is_empty, position|
        if position.blocks?
          is_empty && (next_player_i != position.i || next_player_j != position.j)
        else
          is_empty
        end
      }

      if destination_empty
        player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
        player_position.i = next_player_i
        player_position.j = next_player_j
      end
    end

    def process_attacking_monster(em, entity, next_player_i, next_player_j)
      # Matches where the monster is... (since it could have moved, but not necessarily).
      #
      # Since this system runs before MonsterAISystem, the monsters haven't moved yet.
      # That's why we get monster position from em instead of prev_em.
      monster_position = em.get_component_of_type entity, Position

      # Then deduct monster hp.
      if next_player_i == monster_position.i && next_player_j == monster_position.j
        monster_health = em.get_component_of_type entity, Health
        monster_health.health -= 1
        em.kill_entity entity if monster_health.health <= 0
      end
    end
  end

  class DoLeft < DoDirectionHandler
    def fire(em)
      player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
      process_movement em, player_position.i, player_position.j - 1
    end
  end

  class DoRight < DoDirectionHandler
    def fire(em)
      player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
      process_movement em, player_position.i, player_position.j + 1
    end
  end

  class DoUp < DoDirectionHandler
    def fire(em)
      player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
      process_movement em, player_position.i - 1, player_position.j
    end
  end

  class DoDown < DoDirectionHandler
    def fire(em)
      player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
      process_movement em, player_position.i + 1, player_position.j
    end
  end

  class DoUpLeft < DoDirectionHandler
    def fire(em)
      player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
      process_movement em, player_position.i - 1, player_position.j - 1
    end
  end

  class DoUpRight < DoDirectionHandler
    def fire(em)
      player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
      process_movement em, player_position.i - 1, player_position.j + 1
    end
  end

  class DoDownLeft < DoDirectionHandler
    def fire(em)
      player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
      process_movement em, player_position.i + 1, player_position.j - 1
    end
  end

  class DoDownRight < DoDirectionHandler
    def fire(em)
      player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
      process_movement em, player_position.i + 1, player_position.j + 1
    end
  end

  class ChangeCurrentNode < InputHandler
    def valid?(em)
      world = em.get_component World
      player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
      player_position.i == context[:source_i] &&
        player_position.j == context[:source_j] &&
        context[:source_node_id] == world.current_node_id
    end

    def fire(em)
      world = em.get_component World
      player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
      world.current_node_id = context[:target_node_id]
      player_position.node_id = context[:target_node_id]
      player_position.i = context[:target_i]
      player_position.j = context[:target_j]
    end
  end
end
