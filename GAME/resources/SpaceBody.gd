
extends RigidBody2D

var delta_v = 10.0

onready var dock = get_node('Dock')

func _ready():
	dock.set_meta('dock',true)
	set_fixed_process(false)

func _fixed_process(delta):
	var V = get_global_pos().rotated(deg2rad(90))
	V = V / (get_global_pos().length()*0.01)
	set_linear_velocity(V)




func _on_SpaceBody_mouse_enter():
	get_node('Selected').show()
	print("SDF")


func _on_SpaceBody_mouse_exit():
	get_node('Selected').hide()
