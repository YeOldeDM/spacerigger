
extends RigidBody2D

# WorldSpace reference
onready var world = get_node('../../')

# Shortcuts
onready var cam = get_node('Camera')
onready var thrusters = get_node('Thrusters')
onready var docks = get_node('Docks')

# Controller node
var controller = null

export var Chassis = "Tauro"
export var Model = "Runner"
export var Designation = "A1A-212"
# Velocity force vars
export var delta_v_main = 1260.0
export var delta_v = 500.0
export var delta_r = 5.0
export var damp_power = 1.0

export(int, "I config", "H config") var rcs_config

export var has_retro_thrust = true
export var has_rcs_thrust = true
var thrusters_live = true
export var has_warp_drive = true

export var max_fuel = 16.0


var current_fuel = 0
var current_fuel_use = 0

var target = null
var active_dock = 0
var docked = false

func focus_camera():
	cam.make_current()

func refuel():
	pass

func get_total_mass():
	return self.get_mass()


# Inertial Damping Autopilot Functions

# Enable ANG RID
func enable_angular_dampen():
	if abs(get_angular_velocity()) > 0.001:
		if get_angular_damp() <= 0:
			set_angular_damp(damp_power)
	else:
		set_angular_damp(0)

# Disable ANG RID
func disable_angular_dampen():
	if get_angular_damp() > 0:
		set_angular_damp(0)

# Enable LIN RID
func enable_linear_dampen():
	if get_linear_velocity().length() > 0.001:
		if get_linear_damp() <= 0:
			set_linear_damp(damp_power)
	else:
		set_linear_damp(0)

# Disable LIN RID
func disable_linear_dampen():
	if get_linear_damp() > 0:
		set_linear_damp(0)






func _ready():
	pass

func _get_forward_vector():
	var tr = get_global_transform()
	return tr.basis_xform(Vector2(0,1))

func _get_left_vector():
	var tr = get_global_transform()
	return tr.basis_xform(Vector2(1,0))

func _dock_with(target):
	if docks.get_child(active_dock).touching:
		get_node('DockJoint').set_node_b(docks.get_child(active_dock).touching.get_owner().get_path())
		docked = true

func _undock_from(target):
	if docked:
		get_node('DockJoint').set_node_b(get_path())
		docked = false
		var pushoff = get_total_mass() * -_get_forward_vector() * 100.0
		set_linear_velocity(pushoff)

func _sync_rotation_with(target):
	var dock_body = target.get_owner()
	var t_rot = dock_body.get_rot()
	var d_rot = get_node('Dock').get_rot()
	set_rot(t_rot-d_rot+PI)
		
func _integrate_forces(state):
	# Get
	var delta = state.get_step()
	var lv = state.get_linear_velocity()
	var av = state.get_angular_velocity()
	
	# Do
	if controller:
		
		# Controller Input
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
	
		if cmd.dock:
			_dock_with(target)
		if cmd.undock:
			_undock_from(target)
		
	# Apply Damping
	if get_linear_damp() > 0:
		lv *= 1.0-(get_linear_damp() / get_total_mass())
	if get_angular_damp() > 0:
		av *= 1.0-(get_angular_damp() / get_total_mass())
	
	# Set Velocity
	state.set_linear_velocity(lv)
	state.set_angular_velocity(av)


