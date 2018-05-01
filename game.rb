require 'io/console'

class Game

  def initialize
    em = Recs::EntityManager.new

    world_entity = em.create_tagged_entity Tag::WORLD
    world = World.new [{
      source: :level_1,
      target: :level_2,
      source_i: 3,
      source_j: 3,
      target_i: 2,
      target_j: 2
    }], :level_1
    em.add_component world_entity, world

    monster_entity = em.create_tagged_entity Tag::MONSTER
    em.add_component monster_entity, Health.new(3)
    monster_position = Position.new(3, 10, blocks: true)
    em.add_component monster_entity, monster_position
    em.add_component monster_entity, Renderable.new(ColorizedString['g'].colorize(:green))

    monster_entity = em.create_tagged_entity Tag::MONSTER
    em.add_component monster_entity, Health.new(3)
    monster_position = Position.new(2, 9, blocks: true)
    em.add_component monster_entity, monster_position
    em.add_component monster_entity, Renderable.new(ColorizedString['g'].colorize(:green))

    player_entity = em.create_tagged_entity Tag::PLAYER
    em.add_component player_entity, Health.new(10)
    player_position = Position.new(1, 1, blocks: true)
    em.add_component player_entity, player_position
    em.add_component player_entity, Renderable.new('@')

    rendering_system = RenderingSystem.new
    monster_ai_system = MonsterAISystem.new
    player_input_system = PlayerInputSystem.new
    world_watch_system = WorldWatchSystem.new

    world_watch_system.process_one_game_tick nil, em
    rendering_system.process_one_game_tick em

    loop do
      next_em = Marshal.load Marshal.dump em # Deep dup, so we can compare between them, go back, etc.

      #########################################################################
      # (Possibly) Mutates next_em
      #########################################################################
      player_input_system.process_one_game_tick next_em
      world_watch_system.process_one_game_tick em, next_em
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
