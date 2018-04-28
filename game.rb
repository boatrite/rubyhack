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

  def display_room_component(room_component)
    room_component.room.each do |row|
      display_row row
    end
  end

  def render_state(state, em)
    puts `clear`
    puts "Player HP: #{state[:player_hp]}"
    puts "Monster HP: #{state[:monster_hp]}"
    room_entity = em.get_entity_with_tag Tag::ROOM
    room_component = em.get_component_of_type room_entity, Room
    display_room_component room_component
  end

  def initialize
    em = Recs::EntityManager.new

    room_component = em.create_simple Tag::ROOM

    state = {
      player_position: { x: 1, y: 1 },
      player_hp: 10,
      monster: { x: 10, y: 3 },
      monster_hp: 3
    }

    room_component.room[state[:player_position][:y]][state[:player_position][:x]] = C
    room_component.room[state[:monster][:y]][state[:monster][:x]] = M

    render_state state, em
    loop do
      next_state = Marshal.load Marshal.dump state # Deep dup, so we can compare between states, go back, etc
      next_em = Marshal.load Marshal.dump em # Deep dup, so we can compare between them, go back, etc.

      next_room_component = next_em.get_simple Tag::ROOM

      puts 'Do what?'
      command = STDIN.getch
      case command
      when 'h'
        next_room_component.room[next_state[:player_position][:y]][next_state[:player_position][:x]] = E
        next_state[:player_position][:x] -= 1
      when 'j'
        next_room_component.room[next_state[:player_position][:y]][next_state[:player_position][:x]] = E
        next_state[:player_position][:y] += 1
      when 'k'
        next_room_component.room[next_state[:player_position][:y]][next_state[:player_position][:x]] = E
        next_state[:player_position][:y] -= 1
      when 'l'
        next_room_component.room[next_state[:player_position][:y]][next_state[:player_position][:x]] = E
        next_state[:player_position][:x] += 1
      when 'Q', 'q', 'exit'
        puts 'Bye!'
        exit
      end

      # Mutates next_state
      # TODO Next:
      # These should be systems in an ECS. The bug where the goblin still deals
      # damage to the player would be fixed if the goblin were stored as an
      # entity which is deleted once it's HP falls to zero.
      #
      # Then it would no longer be called up in the MonsterAI system which damages the player.
      PlayerAttackResolver.resolve(state, next_state)
      MonsterAI.resolve(state, next_state, next_em)

      # Doesn't mutate next_state -- returns next_state or (a potentially modified) state.
      next_state, next_em = CollisionResolver.resolve(state, em, next_state, next_em)

      # Weird rendering code?
      next_room_component = next_em.get_simple Tag::ROOM
      next_room_component.room[next_state[:player_position][:y]][next_state[:player_position][:x]] = C
      next_room_component.room[next_state[:monster][:y]][next_state[:monster][:x]] = M if next_state[:monster_hp].nonzero?

      state = next_state
      em = next_em
      render_state state, em
    end
  end
end
