# This system is responsible for creating and destroying the wall entities.
#
# It should be run once before the main loop to initialize the first wall
# entities. In the main loop it should be run after anything that could change
# the Graph component's current_vertex.
class GraphWatchSystem < Recs::System

  def process_one_game_tick(prev_em, em)
    graph = em.get_simple Tag::GRAPH

    if prev_em.nil?
      initialize_current_node em, graph
    else
      node_id = graph.current_node_id

      prev_graph = prev_em.get_simple Tag::GRAPH
      prev_node_id = prev_graph.current_node_id

      if node_id != prev_node_id
        em.kill_entities em.get_entities_with_tag Tag::WALL
        em.kill_entities em.get_entities_with_tag Tag::CONNECTION
        initialize_current_node em, graph
      end
    end
  end

  private

  def initialize_current_node(em, graph)
    graph.current_node.wall_coordinates.each do |i, j|
      wall_entity = em.create_tagged_entity Tag::WALL
      em.add_component wall_entity, Position.new(i, j, blocks: true)
    end

    connection_entity = em.create_tagged_entity Tag::CONNECTION
  end
end
