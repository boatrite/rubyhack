# This system is responsible for creating and destroying the wall entities.
#
# It should be run once before the main loop to initialize the first wall
# entities. In the main loop it should be run after anything that could change
# the Graph component's current_vertex.
class GraphWatchSystem < Recs::System

  def process_one_game_tick(prev_em, em)
    graph_component = em.get_simple Tag::GRAPH

    if prev_em.nil?
      initialize_node em, graph_component.current_node
    else
      node_id = graph_component.current_node_id

      prev_graph_component = prev_em.get_simple Tag::GRAPH
      prev_node_id = prev_graph_component.current_node_id

      if node_id != prev_node_id
        em.kill_entities em.get_entities_with_tag Tag::WALL
        initialize_node em, graph_component.current_node
      end
    end
  end

  private

  def initialize_node(em, node)
    node.wall_coordinates.each do |i, j|
      wall_entity = em.create_tagged_entity Tag::WALL
      em.add_component wall_entity, Position.new(i, j, blocks: true)
    end
  end
end
