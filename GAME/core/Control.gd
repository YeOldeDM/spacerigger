
extends Node

var cmd_list = [
'thrust_pro',
'thrust_retro',
'rcs_pro',
'rcs_retro',
'rcs_left',
'rcs_right',
'yaw_left',
'yaw_right',
'dock',
'undock'
]

var ship

func enable():
	set_fixed_process(true)

func disable():
	set_fixed_process(false)

func get_enabled():
	return is_fixed_processing()


func connect_to(obj):
	obj.controller = self
	for act in cmd_list:
		connect(act, obj, act)
	ship = obj

func disconnect_from(obj):
	for act in cmd_list:
		if is_connected(act, obj, act):
			disconnect(act, obj, act)
	obj.controller = null
	ship = null

func _ready():
	for act in cmd_list:
		add_user_signal(act,['delta'])
	set_fixed_process(true)

func _fixed_process(delta):
	var thrusters = {}
	for i in ship.thrusters.get_children():
		thrusters[i.get_name()] = false
	for act in cmd_list:
		if Input.is_action_pressed(act):
			emit_signal(act, delta)
			
			if act == 'thrust_pro':
				thrusters['ProThrustR'] = true
				thrusters['ProThrustL'] = true
			
			if act == 'thrust_retro':
				thrusters['RetroThrustR'] = true
				thrusters['RetroThrustL'] = true
			
			if act == 'rcs_pro':
				thrusters['RCSProR'] = true
				thrusters['RCSProL'] = true
			
			if act == 'rcs_retro':
				thrusters['RCSRetroR'] = true
				thrusters['RCSRetroL'] = true

			if act == 'rcs_left':
				thrusters['RCSRightF'] = true
				thrusters['RCSRightA'] = true

			if act == 'rcs_right':
				thrusters['RCSLeftF'] = true
				thrusters['RCSLeftA'] = true

			if act == 'yaw_left':
				thrusters['RCSRightF'] = true
				thrusters['RCSLeftA'] = true

			if act == 'yaw_right':
				thrusters['RCSLeftF'] = true
				thrusters['RCSRightA'] = true

	for key in thrusters:
		if thrusters[key]:
			if not ship.thrusters.get_node(key).is_emitting():
				ship.thrusters.get_node(key).set_emitting(true)

		else:
			if ship.thrusters.get_node(key).is_emitting():
				ship.thrusters.get_node(key).set_emitting(false)


