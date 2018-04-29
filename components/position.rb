class Position < Recs::Component
  attr_accessor :i, :j

  def initialize(i, j)
    super()
    @i = i
    @j = j
  end
end
