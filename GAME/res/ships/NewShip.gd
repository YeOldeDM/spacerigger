
extends RigidBody2D

# WorldSpace reference
onready var world = get_node('../../')

# Shortcuts
onready var cam = get_node('Camera')
onready var thrusters = get_node('Thrusters')

# Controller node
var controller = null

export var Chassis = "Tauro"
export var Model = "Runner"
export var Designation = "A1A-212"
# Velocity force vars
export var delta_v_main = 1260.0
export var delta_v = 500.0
export var delta_r = 5.0

export(int, "I config", "H config") var rcs_config

export var has_retro_thrust = true
export var has_rcs_thrust = true
var thrusters_live = true
export var has_warp_drive = true

export var max_fuel = 16.0

export var RID_power = 1.0

var current_fuel = 0
var current_fuel_use = 0

func focus_camera():
	cam.make_current()

func refuel():
	pass

func get_total_mass():
	return self.get_mass()

func _ready():
	pass

func _get_forward_vector():
	var tr = get_global_transform()
	return tr.basis_xform(Vector2(0,1))

func _get_left_vector():
	var tr = get_global_transform()
	return tr.basis_xform(Vector2(1,0))

func _integrate_forces(state):
	# Get
	var delta = state.get_step()
	var lv = state.get_linear_velocity()
	var av = state.get_angular_velocity()
	
	# Do
	if controller:
		var cmd = controller.cmd_state
		if cmd.thrust_pro:
			lv += (_get_forward_vector()*delta_v_main*delta) / get_mass()

		
		if cmd.thrust_retro and has_retro_thrust:
			lv -= (_get_forward_vector()*delta_v_main*delta) / get_mass()


		if cmd.rcs_pro:
			lv += (_get_forward_vector()*delta_v*delta) / get_mass()


		if cmd.rcs_retro:
			lv -= (_get_forward_vector()*delta_v*delta) / get_mass()

			
		if cmd.rcs_left:
			lv += (_get_left_vector()*delta_v*delta) / get_mass()
			
		if cmd.rcs_right:
			lv -= (_get_left_vector()*delta_v*delta) / get_mass()
			
		if cmd.yaw_left:
			av -= (delta_r*delta) / get_mass()
			
		if cmd.yaw_right:
			av += (delta_r*delta) / get_mass()
	
#		for c in cmd:
#			thrusters.set_emission(c, cmd[c])
	# Set
	state.set_linear_velocity(lv)
	state.set_angular_velocity(av)