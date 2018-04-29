# This system is responsible for creating and destroying the wall entities.
#
# It should be run once before the main loop to initialize the first wall
# entities. In the main loop it should be run after anything that could change
# the Graph component's current_vertex.
class GraphWatchSystem < Recs::System

  def process_one_game_tick(prev_em, em)
    if prev_em.nil?
      graph_component = em.get_simple Tag::GRAPH

      graph_component.graph.vertices.each do |name|
        map = File.read "data/#{name}.txt"
        node_entity = em.create_tagged_entity Tag::NODE
        node_component = Node.new(map, name)
        em.add_component node_entity, node_component
      end

      node_entities = em.get_entities_with_component_of_type(Node)
      current_node_component = node_entities
        .map { |entity| em.get_component_of_type entity, Node }
        .find { |node_component| node_component.name == graph_component.current_vertex }

      current_node_component.wall_coordinates.each do |i, j|
        wall_entity = em.create_tagged_entity Tag::WALL
        em.add_component wall_entity, Position.new(i, j, blocks: true)
      end
    else
      prev_graph_component = prev_em.get_simple Tag::GRAPH
      prev_vertex = prev_graph_component.current_vertex

      graph_component = em.get_simple Tag::GRAPH
      vertex = graph_component.current_vertex

      if prev_vertex != vertex
        em.kill_entities em.get_entities_with_tag Tag::WALL

        node_entities = em.get_entities_with_component_of_type(Node)
        current_node_component = node_entities
          .map { |entity| em.get_component_of_type entity, Node }
          .find { |node_component| node_component.name == graph_component.current_vertex }

        current_node_component.wall_coordinates.each do |i, j|
          wall_entity = em.create_tagged_entity Tag::WALL
          em.add_component wall_entity, Position.new(i, j, blocks: true)
        end
      end
    end
  end
end
