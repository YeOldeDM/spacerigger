
extends RigidBody2D

var delta_v = 1.0

onready var dock = get_node('Dock')

func _ready():
	dock.set_meta('dock',true)
	set_fixed_process(true)
	set_angular_velocity(0.0)

func _fixed_process(delta):
	var V = get_global_pos().rotated(deg2rad(90))
	V = V.normalized()*delta_v
	set_linear_velocity(V)
