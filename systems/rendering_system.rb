class RenderingSystem < Recs::System

  def process_one_game_tick(em)
    render_em em
  end

  private

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
end
