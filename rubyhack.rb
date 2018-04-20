#!/usr/bin/env ruby

H = :horizontal_wall
V = :vertical_wall
E = :empty
C = :player

require_relative './collision_resolver'
require_relative './game'

Game.new
