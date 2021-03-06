class RenderingSystem < Recs::System

  def process_one_game_tick(em)
    world = em.get_simple Tag::WORLD
    map = Marshal.load Marshal.dump world.current_node.map # Dedupe so we don't change the actual map object
    # We only want to make changes for rendering then toss that.
    renderable_entities = em.get_entities_with_component_of_type Renderable
    renderable_entities.map { |entity|
      position = em.get_component_of_type entity, Position
      renderable = em.get_component_of_type entity, Renderable
      [position, renderable]
    }
      .select { |position, _| position.node_id == world.current_node_id }
      .sort_by { |_, renderable| renderable.z }
      .each do |position, renderable|
        map[position.i][position.j] = renderable.char
      end

    render_em em, map
  end

  private

  def render_em(em, map)
    puts `clear`

    display_map map

    player_health = em.get_component_of_type_from_tag Tag::PLAYER, Health
    puts "Player HP: #{player_health.health}"

    monster_entities = em.get_entities_with_tag Tag::MONSTER
    monster_entities.each do |entity|
      monster_health = em.get_component_of_type entity, Health
      puts "Monster (#{entity[0..3]}) HP: #{monster_health.health}"
    end
  end

  def display_map(map)
    map.each do |row|
      display_row row
    end
  end

  def display_row(row)
    puts row.join('')
  end
end
