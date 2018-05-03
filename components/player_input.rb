class PlayerInput < Recs::Component
  attr_reader :key, :method_name, :context

  def initialize(key, method_name, context)
    super()
    @key = key
    @method_name = method_name
    @context = context
  end
end
