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
    when M
      'g'
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
    puts "Player HP: #{state[:player_hp]}"
    room = room.map(&:dup)
    room[state[:player_position][:y]][state[:player_position][:x]] = C
    room[state[:monster][:y]][state[:monster][:x]] = M
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
      player_position: { x: 5, y: 5 },
      player_hp: 10,
      monster: { x: 8, y: 8 },
      monster_hp: 3
    }

    render_room room, state

    loop do
      next_state = Marshal.load Marshal.dump state # Deep dup, so we can compare between states, go back, etc

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

      # Mutates state
      MonsterAI.resolve(room, state, next_state)

      # Doesn't mutate state
      next_state = CollisionResolver.resolve(room, state, next_state)

      state = next_state
      render_room room, state
    end
  end
end
