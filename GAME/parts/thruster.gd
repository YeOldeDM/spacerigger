
extends RigidBody2D

onready var pip = get_node('../PIP')

onready var rcs_left = get_node('Function/RCSleft')
onready var rcs_right = get_node('Function/RCSright')
onready var thrust = get_node('Function/Thrust')


func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	var left = Input.is_action_pressed('thrust_left')
	var right = Input.is_action_pressed('thrust_right')
	var mainthrust = Input.is_action_pressed('thrust_primary')
	
	if mainthrust:
		var pos = thrust.get_global_pos()
		var power = thrust.get_node('power').get_global_pos() - pos
		pos.x += rand_range(-10,10)
		pos.y += rand_range(-10,10)
		apply_impulse(pos,-power*delta)
		get_node('../').cont_rcs_left1 = pos
		get_node('../').cont_rcs_left2 = pos+power


	
	if left:
		var pos = rcs_left.get_global_pos()
		var power = rcs_left.get_node('power').get_global_pos() - pos
		apply_impulse(pos,-power*delta)
		get_node('../').cont_rcs_left1 = pos
		get_node('../').cont_rcs_left2 = pos+power

	if right:
		var pos = rcs_right.get_global_pos()
		var power = rcs_right.get_node('power').get_global_pos() - pos
		apply_impulse(pos,-power*delta)
		get_node('../').cont_rcs_left1 = pos
		get_node('../').cont_rcs_left2 = pos+power




