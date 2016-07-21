
extends Node

#	Singleton for the spawning of game objects

func ship(name):
	var obj = load('res://res/ships/'+name+'.tscn')
	if obj:
		return obj.instance()

func world(name):
	var world = load('res://res/worlds/'+name+'.tscn')
	if world:
		return world.instance()
