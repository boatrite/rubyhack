require 'io/console'

class Game

  def initialize
    em = Recs::EntityManager.new

    # TODO I think this is where I want a Graph component that is a graph with graph methods.
    # So I can maybe link them via the graph and stuff.
    map_1 = File.read 'data/map_1.txt'
    node_1_entity = em.create_tagged_entity Tag::NODE
    node_1_component = Node.new(map_1)
    em.add_component node_1_entity, node_1_component
    node_1_component.wall_coordinates.each do |i, j|
      wall_entity = em.create_tagged_entity Tag::WALL
      em.add_component wall_entity, Position.new(i, j, blocks: true)
    end

    monster_entity = em.create_tagged_entity Tag::MONSTER
    em.add_component monster_entity, Health.new(3)
    em.add_component monster_entity, Renderable.new(ColorizedString['g'].colorize(:green))
    monster_position = Position.new(3, 10, blocks: true)
    em.add_component monster_entity, monster_position

    monster_entity = em.create_tagged_entity Tag::MONSTER
    em.add_component monster_entity, Health.new(3)
    em.add_component monster_entity, Renderable.new(ColorizedString['g'].colorize(:green))
    monster_position = Position.new(2, 9, blocks: true)
    em.add_component monster_entity, monster_position

    player_entity = em.create_tagged_entity Tag::PLAYER
    em.add_component player_entity, Health.new(10)
    em.add_component player_entity, Renderable.new('@')
    player_position = Position.new(1, 1, blocks: true)
    em.add_component player_entity, player_position

    rendering_system = RenderingSystem.new
    monster_ai_system = MonsterAISystem.new
    player_input_system = PlayerInputSystem.new

    rendering_system.process_one_game_tick em

    loop do
      next_em = Marshal.load Marshal.dump em # Deep dup, so we can compare between them, go back, etc.

      #########################################################################
      # Mutates next_em
      #########################################################################
      player_input_system.process_one_game_tick next_em
      monster_ai_system.process_one_game_tick em, next_em

      #########################################################################
      # Doesn't mutate next_em -- returns next_em or (a potentially modified) em.
      #########################################################################

      #########################################################################
      # Doesn't mutate next_em or return a different one. Might only ever be rendering.
      #########################################################################
      rendering_system.process_one_game_tick next_em

      em = next_em
    end
  end
end
