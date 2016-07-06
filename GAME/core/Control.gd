
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

func disconnect_from(obj):
	for act in cmd_list:
		if is_connected(act, obj, act):
			disconnect(act, obj, act)
	obj.controller = null

func _ready():
	for act in cmd_list:
		add_user_signal(act,['delta'])
	set_fixed_process(true)

func _fixed_process(delta):
	for act in cmd_list:
		if Input.is_action_pressed(act):
			emit_signal(act, delta)



