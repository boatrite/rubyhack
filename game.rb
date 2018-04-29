require 'io/console'

class Game

  def initialize
    em = Recs::EntityManager.new

    room_component = em.create_simple Tag::ROOM

    monster_entity = em.create_tagged_entity Tag::MONSTER
    em.add_component monster_entity, Health.new(3)
    monster_position = Position.new(10, 3)
    em.add_component monster_entity, monster_position

    monster_entity = em.create_tagged_entity Tag::MONSTER
    em.add_component monster_entity, Health.new(3)
    monster_position = Position.new(9, 2)
    em.add_component monster_entity, monster_position

    player_entity = em.create_tagged_entity Tag::PLAYER
    em.add_component player_entity, Health.new(10)
    player_position = Position.new(1, 1)
    em.add_component player_entity, player_position

    collision_system = CollisionSystem.new
    rendering_system = RenderingSystem.new
    monster_ai_system = MonsterAISystem.new
    player_attack_system = PlayerAttackSystem.new

    rendering_system.process_one_game_tick em
    loop do
      next_em = Marshal.load Marshal.dump em # Deep dup, so we can compare between them, go back, etc.

      puts 'Do what?'
      command = STDIN.getch
      case command
      when 'h'
        next_player_position = next_em.get_component_of_type_from_tag Tag::PLAYER, Position
        next_player_position.x -= 1
      when 'j'
        next_player_position = next_em.get_component_of_type_from_tag Tag::PLAYER, Position
        next_player_position.y += 1
      when 'k'
        next_player_position = next_em.get_component_of_type_from_tag Tag::PLAYER, Position
        next_player_position.y -= 1
      when 'l'
        next_player_position = next_em.get_component_of_type_from_tag Tag::PLAYER, Position
        next_player_position.x += 1
      when 'Q', 'q', 'exit'
        puts 'Bye!'
        exit
      end

      #########################################################################
      # Mutates next_em
      #########################################################################
      player_attack_system.process_one_game_tick em, next_em
      monster_ai_system.process_one_game_tick em, next_em

      #########################################################################
      # Doesn't mutate next_em -- returns next_em or (a potentially modified) em.
      #########################################################################
      next_em = collision_system.process_one_game_tick em, next_em

      #########################################################################
      # Doesn't mutate next_em or return a different one. Might only ever be rendering.
      #########################################################################
      rendering_system.process_one_game_tick next_em

      em = next_em
    end
  end
end
