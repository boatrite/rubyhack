class Position < Recs::Component
  attr_accessor :x, :y

  def initialize(x, y)
    super()
    @x = x
    @y = y
  end
end
