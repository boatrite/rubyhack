class World < Recs::Component
  attr_accessor :current_node_id
  attr_reader :graph

  def initialize(world_config, current_node_id)
    super()

    rgl_data = world_config.flat_map { |h| [h[:source], h[:target]] }
    @graph = RGL::AdjacencyGraph[*rgl_data]
    @graph.write_to_graphic_file 'jpg'
    @current_node_id = current_node_id

    @nodes = @graph.vertices.map do |node_id|
      map = File.read "data/#{node_id}.txt"
      Node.new node_id, map
    end

    @edges = @graph.edges.map do |rgl_edge|
      source_node_id = rgl_edge.source
      target_node_id = rgl_edge.target
      edge_config = world_config.find { |spec| spec[:source] == source_node_id && spec[:target] == target_node_id }
      Edge.new source_node_id, target_node_id, edge_config.slice(:source_i, :source_j, :target_i, :target_j)
    end
  end

  def current_node
    @nodes.find { |node| node.id == @current_node_id }
  end

  def current_node_edges
    @graph.adjacent_vertices(@current_node_id).map do |adjacent_node_id|
      @edges.find { |edge| (edge.source == @current_node_id && edge.target == adjacent_node_id) ||
                    (edge.source == adjacent_node_id && edge.target == @current_node_id) }
    end
  end

  class Node
    attr_reader :id, :map

    def initialize(id, map)
      @id = id
      @map = map.split("\n").map(&:chars)
    end

    def wall_coordinates
      wall_characters = %w(─ │ ┌ ┐ └ ┘)
      @map.flat_map.with_index do |row, i|
        row.map.with_index do |x, j|
          wall_characters.include?(x) ? [i, j] : nil
        end
      end.compact
    end

    def to_s
      @id
    end
  end

  class Edge
    attr_reader :source, :target, :source_i, :source_j, :target_i, :target_j

    def initialize(source, target, source_i:, source_j:, target_i:, target_j:)
      @source = source
      @target = target
      @source_i = source_i
      @source_j = source_j
      @target_i = target_i
      @target_j = target_j
    end

    def coordinates_on_node(node_id)
      node_id == @source ? [@source_i, @source_j] : [@target_i, @target_j]
    end

    def connecting_node_id(node_id)
      node_id == @source ? @target : @source
    end
  end
end
