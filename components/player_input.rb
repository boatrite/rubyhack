class PlayerInput < Recs::Component
  attr_reader :key

  def initialize(key, method_name, context)
    super()
    @key = key
    @method_name = method_name
    @context = context
  end

  def on_key_press
    PlayerInput.method(@method_name).curry(2)[@context]
  end

  def self.change_current_node(context, em)
    world = em.get_simple Tag::WORLD
    world.current_node_id = context[:connecting_node_id]

    player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
    player_position.i = context[:i]
    player_position.j = context[:j]
  end
end
