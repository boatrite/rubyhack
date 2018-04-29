require 'io/console'

class Game

  def initialize
    em = Recs::EntityManager.new

    node_component = em.create_simple Tag::NODE

    monster_entity = em.create_tagged_entity Tag::MONSTER
    em.add_component monster_entity, Health.new(3)
    monster_position = Position.new(3, 10, blocks: true)
    em.add_component monster_entity, monster_position

    monster_entity = em.create_tagged_entity Tag::MONSTER
    em.add_component monster_entity, Health.new(3)
    monster_position = Position.new(2, 9, blocks: true)
    em.add_component monster_entity, monster_position

    player_entity = em.create_tagged_entity Tag::PLAYER
    em.add_component player_entity, Health.new(10)
    player_position = Position.new(1, 1, blocks: true)
    em.add_component player_entity, player_position

    rendering_system = RenderingSystem.new
    monster_ai_system = MonsterAISystem.new
    player_input_system = PlayerInputSystem.new

    node_component.map.each_with_index do |row, i|
      row.each_with_index do |x, j|
        if WALLS.include? x
          wall_entity = em.create_tagged_entity Tag::WALL
          em.add_component wall_entity, Position.new(i, j, blocks: true)
        end
      end
    end

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
