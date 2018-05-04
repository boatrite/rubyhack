require 'yaml'

class PlayerInputSystem < Recs::System

  def process_one_game_tick(em)
    puts 'Do what?'
    key_pressed = STDIN.getch
    player_inputs = em.get_components(PlayerInput)
    player_inputs
      .select { |player_input| player_input.key == key_pressed }
      .map { |player_input| player_input.handler_class.new(player_input.context, em) }
      .select(&:valid?)
      .each(&:fire)
  end

  private

  class InputHandler
    attr_reader :context

    def initialize(context, em)
      @context = context
      @em = em
    end

    def valid?
      true
    end
  end

  class DumpDetails < InputHandler
    def fire
      File.write 'development.log', @em.dump_details
    end
  end

  class SaveAndQuit < InputHandler
    def fire
      File.write SAVEFILE, Marshal.dump(@em)
      File.write 'development.yaml', YAML.dump(@em)
      puts 'Bye!'
      exit
    end
  end

  class DoDirectionHandler < InputHandler
    def fire
      @next_player_position = Marshal.load Marshal.dump(
        @em.get_component_of_type_from_tag Tag::PLAYER, Position
      )
      yield
      process_movement
    end

    private

    def process_movement
      # If the player is moving at an enemy, resolve attacking it. This removes
      # the entity if it is killed which will let the destination_empty check
      # pass for the spot the enemy had, so the player will move into that
      # spot.

      # TODO What do you think about switching order of params entity and Position,
      # so that it's @em.get_component_of_type Position, entity
      # Turns the map into `monster_entities.map &@em.method(:get_component_of_type).curry(2)[Position]`

      monster_entities = @em.get_entities_with_tag(Tag::MONSTER)
        .map { |entity| [entity, @em.get_component_of_type(entity, Position)] }
        .select { |_, monster_position| @next_player_position.at? monster_position }
        .map { |entity, _| [entity, @em.get_component_of_type(entity, Health)] }
        .each { |_, monster_health| monster_health.health -= 1 }
        .select { |_, monster_health| monster_health.health <= 0 }
        .each { |entity, _| @em.kill_entity entity }

      # Figure out if there is something in the way of where the player is trying to move.
      world = @em.get_component World
      destination_empty = @em.get_components(Position).lazy
        .select(&@next_player_position.method(:at?))
        .select(&:blocks?)
        .none?

      if destination_empty
        player_position = @em.get_component_of_type_from_tag Tag::PLAYER, Position
        player_position.i = @next_player_position.i
        player_position.j = @next_player_position.j
      end
    end
  end

  class DoLeft < DoDirectionHandler
    def fire
      super do
        @next_player_position.j -= 1
      end
    end
  end

  class DoRight < DoDirectionHandler
    def fire
      super do
        @next_player_position.j += 1
      end
    end
  end

  class DoUp < DoDirectionHandler
    def fire
      super do
        @next_player_position.i -= 1
      end
    end
  end

  class DoDown < DoDirectionHandler
    def fire
      super do
        @next_player_position.i += 1
      end
    end
  end

  class DoUpLeft < DoDirectionHandler
    def fire
      super do
        @next_player_position.i -= 1
        @next_player_position.j -= 1
      end
    end
  end

  class DoUpRight < DoDirectionHandler
    def fire
      super do
        @next_player_position.i -= 1
        @next_player_position.j += 1
      end
    end
  end

  class DoDownLeft < DoDirectionHandler
    def fire
      super do
        @next_player_position.i += 1
        @next_player_position.j -= 1
      end
    end
  end

  class DoDownRight < DoDirectionHandler
    def fire
      super do
        @next_player_position.i += 1
        @next_player_position.j += 1
      end
    end
  end

  class ChangeCurrentNode < InputHandler
    def valid?
      world = @em.get_component World
      player_position = @em.get_component_of_type_from_tag Tag::PLAYER, Position
      player_position.i == context[:source_i] &&
        player_position.j == context[:source_j] &&
        context[:source_node_id] == world.current_node_id
    end

    def fire
      world = @em.get_component World
      player_position = @em.get_component_of_type_from_tag Tag::PLAYER, Position
      # Consider having some system (WorldWatch probably) look for changes to
      # player_position.node_id and automatically change world.current_node_id.
      #
      # That should work given the order and that other systems besides
      # PlayerInputSystem are run after WorldWatch system.
      world.current_node_id = context[:target_node_id]
      player_position.node_id = context[:target_node_id]
      player_position.i = context[:target_i]
      player_position.j = context[:target_j]
    end
  end
end
