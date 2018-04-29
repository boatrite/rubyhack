class PlayerInputSystem < Recs::System

  def process_one_game_tick(next_em)
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
  end
end
