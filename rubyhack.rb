#!/usr/bin/env ruby

H = :horizontal_wall
V = :vertical_wall
E = :empty
C = :player
M = :goblin

require_relative './collision_resolver'
require_relative './monster_ai'
require_relative './player_attack_resolver'
require_relative './game'

Game.new
