
extends Node

#	INPUT CONTROLLER NODE
#
#	Transfers player input into commands
#	to a game ship.



# Game node
onready var game = get_node('/root/Game')

# List of current Actions used by Controller.
#	(update this as new actions are added)
var cmd = [
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
var controlled

var cmd_state = {}


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
func plug_in(obj):
	obj.controller = self
	controlled = obj
	obj.focus_camera()

# Unplug from controlled object
func unplug():
	controlled.controller = null
	controlled = null



# Init
func _ready():
	for act in cmd:
		cmd_state[act] = false
		#add_user_signal(act,['delta'])
	set_fixed_process(true)




#	CONTROL PROCESS LOOP
func _fixed_process(delta):
	for act in cmd_state:
		cmd_state[act] = false
		if Input.is_action_pressed(act):
			cmd_state[act] = true
	
	if controlled:
		controlled.process(delta, cmd_state)

	
	
	# If the ship has a target..
	if controlled.target:
		var laser = controlled.get_node('Hardpoints').get_child(0)
		laser.look_at(controlled.target.get_global_pos())
	
	# If the controlled is docked..
	if controlled.dock_target and controlled.docked:
		controlled.sync_rot_with_dock()


