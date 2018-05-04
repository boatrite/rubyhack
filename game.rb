require 'io/console'

class Game

  def initialize(em)
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
      # Doesn't mutate next_em or return a different one. Might only ever be
      # rendering.
      #########################################################################
      rendering_system.process_one_game_tick next_em

      em = next_em
    end
  end
end
