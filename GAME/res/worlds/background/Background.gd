
extends Node2D

export var base_scale = 1.0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func parallax(origin):
	if get_child_count() > 0:
		for child in get_children():
			child.parallax(origin)
	
