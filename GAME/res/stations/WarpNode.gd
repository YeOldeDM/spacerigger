
extends StaticBody2D

export var destination = "None"
export var target_node = "None"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass




func _on_Influence_body_enter( body ):
	if 'has_warp_drive' in body:
		if body.has_warp_drive == true:
			print(body.get_name()+ " "+ body.shipID+ " has entered my warp zone!")
