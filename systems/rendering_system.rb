class RenderingSystem < Recs::System

  def process_one_game_tick(em)
    room_component = em.get_simple Tag::ROOM
    room = Marshal.load Marshal.dump room_component.room # Dedupe so we don't change the actual room object
                                                         # We only want to make changes for rendering then toss that.
    player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
    room[player_position.i][player_position.j] = C

    monster_entities = em.get_entities_with_tag Tag::MONSTER
    monster_entities.each do |entity|
      monster_position = em.get_component_of_type entity, Position
      room[monster_position.i][monster_position.j] = M
    end

    render_em em, room
  end

  private

  def render_em(em, room)
    puts `clear`

    player_health = em.get_component_of_type_from_tag Tag::PLAYER, Health
    puts "Player HP: #{player_health.health}"

    monster_entities = em.get_entities_with_tag Tag::MONSTER
    monster_entities.each do |entity|
      monster_health = em.get_component_of_type entity, Health
      puts "Monster (#{entity[0..3]}) HP: #{monster_health.health}"
    end

    display_room room
  end

  def display_room(room)
    room.each do |row|
      display_row row
    end
  end

  def display_row(row)
    puts row.map(&method(:display_entity)).join('')
  end

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
end
