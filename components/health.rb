class Health < Recs::Component
  attr_accessor :health

  def initialize(health)
    super()
    @health = health
  end
end
