
extends Node

#	INPUT CONTROLLER NODE
#
#	Transfers player input into commands
#	to a game ship.



# Game node
onready var game = get_node('/root/Game')

# List of current Actions used by Controller.
#	(update this as new actions are added)
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

#	The thing this Controller is controlling
var ship

# Turn controls on
func enable():
	set_fixed_process(true)

# Turn controls off
func disable():
	set_fixed_process(false)

# Get control enabled state
func get_enabled():
	return is_fixed_processing()

# Plug into an object
func connect_to(obj):
	obj.controller = self
	for act in cmd_list:
		connect(act, obj, act)
	ship = obj

# Unplug from an object
func disconnect_from(obj):
	for act in cmd_list:
		if is_connected(act, obj, act):
			disconnect(act, obj, act)
	obj.controller = null
	ship = null

# Init
func _ready():
	for act in cmd_list:
		add_user_signal(act,['delta'])
	set_fixed_process(true)




#	CONTROL PROCESS LOOP
func _fixed_process(delta):
	
	# Get thruster data
	var thrusters = {}
	for i in ship.thrusters.get_children():
		thrusters[i.get_name()] = false
	
	
	# Search command list for Input event matches
	for act in cmd_list:
		if Input.is_action_pressed(act):
			emit_signal(act, delta)
			
			# Set thruster data
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
	
	# Set emission state of ship thrusters
	for key in thrusters:
		if thrusters[key]:
			if not ship.thrusters.get_node(key).is_emitting():
				ship.thrusters.get_node(key).set_emitting(true)

		else:
			if ship.thrusters.get_node(key).is_emitting():
				ship.thrusters.get_node(key).set_emitting(false)
	
	
	# If the ship has a target..
	if ship.target:
		var laser = ship.get_node('Hardpoints').get_child(0)
		laser.look_at(ship.target.get_global_pos())
	
	# If the ship is docked..
	if ship.dock_target and ship.docked:
		ship.sync_rot_with_dock()