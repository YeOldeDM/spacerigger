
extends StaticBody2D

export var destination = "None"
export var target_node = "None"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass




func _on_Influence_body_enter( body ):
	if body.has_method('set_warp_zone'):
		body.set_warp_zone(self)

func _on_Influence_body_exit( body ):
	if body.has_method('clear_warp_zone'):
		body.clear_warp_zone()
