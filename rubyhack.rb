#!/usr/bin/env ruby

H = :horizontal_wall
V = :vertical_wall
E = :empty
C = :player

room = [
  [H]*11,
  [V, *[E]*9, V],
  [V, *[E]*9, V],
  [V, *[E]*9, V],
  [V, *[E]*9, V],
  [V, *[E]*9, V],
  [V, *[E]*9, V],
  [V, *[E]*9, V],
  [V, *[E]*9, V],
  [V, *[E]*9, V],
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

def render_room(room, state)
  room = room.map(&:dup)
  room[state[:player_position][:y]][state[:player_position][:x]] = C
  display_room room
end

state = {
  player_position: { x: 5, y: 5 }
}

render_room room, state

loop do
  puts 'Do what?'
  command = gets.chomp # TODO Find out how to not need to hit Enter.
  puts command
  case command
  when 'h'
    state[:player_position][:x] -= 1
  when 'j'
    state[:player_position][:y] += 1
  when 'k'
    state[:player_position][:y] -= 1
  when 'l'
    state[:player_position][:x] += 1
  when 'Q', 'q', 'exit'
    puts 'Bye!'
    exit
  end

  render_room room, state
end
