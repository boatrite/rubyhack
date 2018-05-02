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
end
