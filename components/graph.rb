class Graph < Recs::Component
  attr_reader :graph, :current_vertex

  def initialize(graph_specification, current_vertex)
    super()

    @graph = RGL::AdjacencyGraph[*graph_specification]
    @graph.write_to_graphic_file 'jpg'
    @current_vertex = current_vertex
  end
end
