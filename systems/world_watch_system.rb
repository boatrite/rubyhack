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
        initialize_current_node em, world
      end
    end
  end

  private

  def initialize_current_node(em, world)
    world.current_node.wall_coordinates.each do |i, j|
      wall_entity = em.create_tagged_entity Tag::WALL
      em.add_component wall_entity, Position.new(i, j, world.current_node_id, blocks: true)
    end

    world.current_node_edges.each do |edge|
      connection_entity = em.create_tagged_entity Tag::CONNECTION
      current_node_id = world.current_node_id
      i, j = edge.coordinates_on_node(current_node_id)
      em.add_component connection_entity, Position.new(i, j, world.current_node_id, blocks: false)
      em.add_component connection_entity, Renderable.new('>')
      connecting_node_id = edge.connecting_node_id(current_node_id)
      connecting_i, connecting_j = edge.coordinates_on_node(connecting_node_id)
      em.add_component connection_entity, PlayerInput.new('>', :change_current_node, {
        current_node_id: world.current_node_id,
        connecting_node_id: connecting_node_id,
        source_i: i,
        source_j: j,
        target_i: connecting_i,
        target_j: connecting_j
      })
    end
  end
end
