class Room < Recs::Component
  attr_reader :room

  def initialize
    super
    @room = [
      [H]*15,
      [V, *[E]*13, V],
      [V, *[E]*13, V],
      [V, *[E]*13, V],
      [H]*15
    ]
  end
end
