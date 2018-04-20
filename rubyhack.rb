#!/usr/bin/env ruby

H = :horizontal_wall
V = :vertical_wall
E = :empty
C = :player

ROOM = [
  [H]*11,
  *[[V, *[E]*9, V]]*4,
  [V, *[E]*4, C, *[E]*4, V],
  *[[V, *[E]*9, V]]*4,
  [H]*11
]

def display_entity(entity)
  case entity
  when V
    '|'
  when H
    '-'
  when E
    '.'
  when C
    '@'
  else
    raise "Don't know how to display entity: #{entity}"
  end
end

def display_row(row)
  puts row.map(&method(:display_entity)).join('')
end

def display_room(room)
  room.each do |row|
    display_row row
  end
end

display_room ROOM
