class Graph < Recs::Component
  attr_reader :graph, :current_vertex

  def initialize(graph_specification)
    super()

    @graph = RGL::AdjacencyGraph[*graph_specification]
    @current_vertex = :level_1
  end
end
