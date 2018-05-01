# This system is responsible for creating and destroying the wall entities.
#
# It should be run once before the main loop to initialize the first wall
# entities. In the main loop it should be run after anything that could change
# the World component's current_vertex.
class WorldWatchSystem < Recs::System

  def process_one_game_tick(prev_em, em)
    world = em.get_simple Tag::WORLD

    if prev_em.nil?
      initialize_current_node em, world
    else
      node_id = world.current_node_id

      prev_world = prev_em.get_simple Tag::WORLD
      prev_node_id = prev_world.current_node_id

      if node_id != prev_node_id
        em.kill_entities em.get_entities_with_tag Tag::WALL
        em.kill_entities em.get_entities_with_tag Tag::CONNECTION
        initialize_current_node em, world
      end
    end
  end

  private

  def initialize_current_node(em, world)
    world.current_node.wall_coordinates.each do |i, j|
      wall_entity = em.create_tagged_entity Tag::WALL
      em.add_component wall_entity, Position.new(i, j, blocks: true)
    end

    world.current_node_edges.each do |edge|
      connection_entity = em.create_tagged_entity Tag::CONNECTION
      i, j = edge.coordinates_on_node(world.current_node_id)
      em.add_component connection_entity, Position.new(i, j, blocks: false)
      em.add_component connection_entity, Renderable.new('>')
    end
  end
end
