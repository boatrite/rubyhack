require 'io/console'

class Game
  def display_entity(entity)
    case entity
    when V
      '|'
    when H
      '-'
    when E
      '.'
    when C
      '@'
    else
      raise "Don't know how to display entity: #{entity}"
    end
  end

  def display_row(row)
    puts row.map(&method(:display_entity)).join('')
  end

  def display_room(room)
    room.each do |row|
      display_row row
    end
  end

  def render_room(room, state)
    puts `clear`
    room = room.map(&:dup)
    room[state[:player_position][:y]][state[:player_position][:x]] = C
    display_room room
  end

  def initialize
    room = [
      [H]*11,
      [V, *[E]*9, V],
      [V, *[E]*9, V],
      [V, *[E]*9, V],
      [V, *[E]*9, V],
      [V, *[E]*9, V],
      [V, *[E]*9, V],
      [V, *[E]*9, V],
      [V, *[E]*9, V],
      [V, *[E]*9, V],
      [H]*11
    ]
    state = {
      player_position: { x: 5, y: 5 }
    }

    render_room room, state

    loop do
      next_state = Marshal.load Marshal.dump state

      puts 'Do what?'
      command = STDIN.getch
      case command
      when 'h'
        next_state[:player_position][:x] -= 1
      when 'j'
        next_state[:player_position][:y] += 1
      when 'k'
        next_state[:player_position][:y] -= 1
      when 'l'
        next_state[:player_position][:x] += 1
      when 'Q', 'q', 'exit'
        puts 'Bye!'
        exit
      end

      next_state = CollisionResolver.resolve(room, state, next_state)

      state = next_state
      render_room room, state
    end
  end
end
