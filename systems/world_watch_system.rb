# This system is responsible for creating and destroying the wall entities.
#
# It should be run once before the main loop to initialize the first wall
# entities. In the main loop it should be run after anything that could change
# the World component's current_node_id.
class WorldWatchSystem < Recs::System

  def process_one_game_tick(prev_em, em)
    world = em.get_simple Tag::WORLD

    if prev_em.nil?
      initialize_node em, world, world.current_node
    else
      node_id = world.current_node_id

      prev_world = prev_em.get_simple Tag::WORLD
      prev_node_id = prev_world.current_node_id

      if node_id != prev_node_id
        initialize_node em, world, world.current_node
      end
    end
  end

  private

  def initialize_node(em, world, node)
    node.wall_coordinates.each do |i, j|
      wall_entity = em.create_tagged_entity Tag::WALL
      em.add_component wall_entity, Position.new(i, j, node.id, blocks: true)
    end

    world.node_edges(node.id).each do |edge|
      connection_entity = em.create_tagged_entity Tag::CONNECTION
      i, j = edge.coordinates_on_node(node.id)
      em.add_component connection_entity, Position.new(i, j, node.id, blocks: false)
      em.add_component connection_entity, Renderable.new('>')
      connecting_node_id = edge.connecting_node_id(node.id)
      connecting_i, connecting_j = edge.coordinates_on_node(connecting_node_id)
      em.add_component connection_entity, PlayerInput.new('>', :change_current_node, {
        source_node_id: node.id,
        source_i: i,
        source_j: j,
        target_node_id: connecting_node_id,
        target_i: connecting_i,
        target_j: connecting_j
      })
    end
  end
end
