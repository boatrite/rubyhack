class PlayerInput < Recs::Component
  attr_reader :key, :handler_class, :context

  def initialize(key, handler_class, context = nil)
    super()
    @key = key
    @handler_class = handler_class
    @context = context
  end

  def handler
    @handler_class.new @context
  end
end
