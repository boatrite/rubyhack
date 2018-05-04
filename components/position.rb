class Position < Recs::Component
  attr_accessor :i, :j, :node_id
  attr_reader :blocks

  def initialize(i, j, node_id, blocks:)
    super()
    @i = i
    @j = j
    @node_id = node_id
    @blocks = blocks
  end

  def blocks?
    @blocks
  end

  def at?(other_position)
    other_position.node_id == @node_id &&
      other_position.i == @i &&
      other_position.j == @j
  end
end
