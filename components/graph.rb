class Graph < Recs::Component
  attr_reader :current_vertex

  def initialize(em)
    super()

    # Super nasty. Shouldn't be making other components and entities in a component.
    map_1 = File.read 'data/map_1.txt'
    node_1_entity = em.create_tagged_entity Tag::NODE
    node_1_component = Node.new(map_1, 'Level 1')
    em.add_component node_1_entity, node_1_component

    map_2 = File.read 'data/map_2.txt'
    node_2_entity = em.create_tagged_entity Tag::NODE
    node_2_component = Node.new(map_2, 'Level 2')
    em.add_component node_2_entity, node_2_component

    @graph = RGL::AdjacencyGraph[node_1_component,node_2_component]
    @current_vertex = node_2_component
  end
end
