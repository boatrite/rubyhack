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

  def render_em(em)
    puts `clear`
    player_health = em.get_component_of_type_from_tag Tag::PLAYER, Health
    monster_health = em.get_component_of_type_from_tag Tag::MONSTER, Health
    puts "Player HP: #{player_health.health}"
    puts "Monster HP: #{monster_health.health}"
    room_entity = em.get_entity_with_tag Tag::ROOM
    room_component = em.get_component_of_type room_entity, Room
    display_room_component room_component
  end

  def initialize
    em = Recs::EntityManager.new

    room_component = em.create_simple Tag::ROOM

    monster_entity = em.create_tagged_entity Tag::MONSTER
    em.add_component monster_entity, Health.new(3)
    monster_position = Position.new(10, 3)
    em.add_component monster_entity, monster_position

    player_entity = em.create_tagged_entity Tag::PLAYER
    em.add_component player_entity, Health.new(10)
    player_position = Position.new(1, 1)
    em.add_component player_entity, player_position

    room_component.room[player_position.y][player_position.x] = C
    room_component.room[monster_position.y][monster_position.x] = M

    render_em em
    loop do
      next_em = Marshal.load Marshal.dump em # Deep dup, so we can compare between them, go back, etc.

      next_room_component = next_em.get_simple Tag::ROOM
      next_player_position = next_em.get_component_of_type_from_tag Tag::PLAYER, Position

      puts 'Do what?'
      command = STDIN.getch
      case command
      when 'h'
        next_room_component.room[next_player_position.y][next_player_position.x] = E
        next_player_position.x -= 1
      when 'j'
        next_room_component.room[next_player_position.y][next_player_position.x] = E
        next_player_position.y += 1
      when 'k'
        next_room_component.room[next_player_position.y][next_player_position.x] = E
        next_player_position.y -= 1
      when 'l'
        next_room_component.room[next_player_position.y][next_player_position.x] = E
        next_player_position.x += 1
      when 'Q', 'q', 'exit'
        puts 'Bye!'
        exit
      end

      # Mutates next_em
      # TODO Next:
      # These should be systems in an ECS. The bug where the goblin still deals
      # damage to the player would be fixed if the goblin were stored as an
      # entity which is deleted once it's HP falls to zero.
      #
      # Then it would no longer be called up in the MonsterAI system which damages the player.
      PlayerAttackResolver.resolve(em, next_em)
      MonsterAI.resolve(em, next_em)

      # Doesn't mutate next_em -- returns next_em or (a potentially modified) em.
      next_em = CollisionResolver.resolve(em, next_em)

      # Weird rendering code?
      next_room_component = next_em.get_simple Tag::ROOM
      next_player_position = next_em.get_component_of_type_from_tag Tag::PLAYER, Position
      next_room_component.room[next_player_position.y][next_player_position.x] = C

      next_monster_position = next_em.get_component_of_type_from_tag Tag::MONSTER, Position
      next_monster_health = next_em.get_component_of_type_from_tag Tag::MONSTER, Health
      next_room_component.room[next_monster_position.y][next_monster_position.x] = M if next_monster_health.health.nonzero?

      em = next_em
      render_em em
    end
  end
end
