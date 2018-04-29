class Node < Recs::Component
  attr_reader :map

  def initialize
    super
    map = <<~MAP
    ┌─────────────┐  ┌─────┐
    │.............└──┘.....│
    │......................│
    │.............┌──┐.....│
    └─────────────┘  └─┐.┌─┘
                       │.│
                       │.│
                       │.│      ┌─────────┐
                       │.│      │.........│
                       │.│      │.........│
                       │.│      │.........│
                       │.│      │.........│
                       │.│      │.........│
                       │.│      │..┌──────┘
                       │.└──────┘..│
                       │...........│
                       │...........│
                       │......┌────┘
                       │......│
                       │......│
                       │......│
                       └──────┘
    MAP
    @map = map.split("\n").map(&:chars)
  end
end