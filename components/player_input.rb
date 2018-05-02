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

  def trigger_conditions_met?(em)
    PlayerInput.method("#{@method_name}_conditions_met?").call @context, em
  end

  def self.change_current_node(context, em)
    world = em.get_component World
    player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
    world.current_node_id = context[:target_node_id]
    player_position.node_id = context[:target_node_id]
    player_position.i = context[:target_i]
    player_position.j = context[:target_j]
  end

  def self.change_current_node_conditions_met?(context, em)
    world = em.get_component World
    player_position = em.get_component_of_type_from_tag Tag::PLAYER, Position
    player_position.i == context[:source_i] &&
      player_position.j == context[:source_j] &&
      context[:source_node_id] == world.current_node_id
  end
end
