class Node < Recs::Component
  attr_reader :map, :name

  def initialize(map, name)
    super()
    @map = map.split("\n").map(&:chars)
    @name = name
  end

  def wall_coordinates
    wall_characters = %w(─ │ ┌ ┐ └ ┘)
    @map.flat_map.with_index do |row, i|
      row.map.with_index do |x, j|
        wall_characters.include?(x) ? [i, j] : nil
      end
    end.compact
  end

  def to_s
    @name
  end
end
