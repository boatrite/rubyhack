class Renderable < Recs::Component
  requires_component_of_type 'Position'

  attr_reader :char, :z

  def initialize(char, z: 0)
    if char.class == String
      raise 'Renderable char must be 1 character long' if char.length > 1
    else
      raise 'Renderable char must be 1 character long' if char.uncolorize.length > 1
    end
    @char = char
    @z = z
  end
end
