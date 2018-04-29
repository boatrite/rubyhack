class Position < Recs::Component
  attr_accessor :i, :j
  attr_reader :blocks

  def initialize(i, j, blocks:)
    super()
    @i = i
    @j = j
    @blocks = blocks
  end

  def blocks?
    @blocks
  end
end
