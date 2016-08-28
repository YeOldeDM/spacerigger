
extends Node2D

onready var ship = get_owner()


var ThrustBlock = {
	"thrust_pro":		[],
	"thrust_retro":	[],
	"rcs_pro":		[],
	"rcs_retro":	[],
	"rcs_left":		[],
	"rcs_right":	[],
	"yaw_left":		[],
	"yaw_right":	[]
	}

func set_emission(action, state):
	if ThrustBlock.has(action):
		for t in ThrustBlock[action]:
			if state:	
				t.turn_on()
				print(t.get_name())
			else:
				t.turn_off()

func _process(delta):
	for action in ship.controller.cmd_state:
		set_emission(action, ship.controller.cmd_state[action])

func _ready():
	set_process(true)
	for t in get_children():
		if t.thrust_type == t.TYPE_MAIN:
			if t.thrust_direction == t.DIRECTION_PROGRADE:
				ThrustBlock.thrust_pro.append(t)
			elif t.thrust_direction == t.DIRECTION_RETROGRADE:
				ThrustBlock.thrust_retro.append(t)
		
		elif t.thrust_type == t.TYPE_REACTION:
			if t.thrust_direction == t.DIRECTION_PROGRADE:
				ThrustBlock.rcs_pro.append(t)

				if ship.rcs_config == 1:	# H configuration
					if t.thrust_placement == t.PLACEMENT_STARBOARD:
						ThrustBlock.yaw_left.append(t)
					elif t.thrust_placement == t.PLACEMENT_PORT:
						ThrustBlock.yaw_right.append(t)


			elif t.thrust_direction == t.DIRECTION_RETROGRADE:
				ThrustBlock.rcs_retro.append(t)
				
				if ship.rcs_config == 1:	# H configuration
					if t.thrust_placement == t.PLACEMENT_PORT:
						ThrustBlock.yaw_left.append(t)
					elif t.thrust_placement == t.PLACEMENT_STARBOARD:
						ThrustBlock.yaw_right.append(t)


			elif t.thrust_direction == t.DIRECTION_PORT:
				ThrustBlock.rcs_right.append(t)
				
				if ship.rcs_config == 0:	# I configuration
					if t.thrust_placement == t.PLACEMENT_AFT:
						ThrustBlock.yaw_left.append(t)
					elif t.thrust_placement == t.PLACEMENT_FORE:
						ThrustBlock.yaw_right.append(t)

			elif t.thrust_direction == t.DIRECTION_STARBOARD:
				ThrustBlock.rcs_left.append(t)
				if ship.rcs_config == 0:	# I configuration
					if t.thrust_placement == t.PLACEMENT_FORE:
						ThrustBlock.yaw_left.append(t)
					elif t.thrust_placement == t.PLACEMENT_AFT:
						ThrustBlock.yaw_right.append(t)
			
	for key in ThrustBlock:
		print(key+'\n')
		for i in ThrustBlock[key]:
			print(i.get_name())
		print('\n\n')



