
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

var in_warp_zone = null

export var max_fuel = 16.0


var current_fuel = 0 setget _set_current_fuel
var current_fuel_use = 0.0
var current_thrust_force = 0.0

var target = null
var target_dock = 0
var active_dock = 0
var docked = false
var pending_pushoff = false
var pending_dock = false



func refuel():
	current_fuel = max_fuel

func get_total_mass():
	return self.get_mass()

func add_fuel(amt=0):
	amt /= 10000
	var new_fuel = current_fuel + amt
	#print(amt)
	set('current_fuel', new_fuel)

func set_warp_zone(target_node):
	in_warp_zone = target_node

func clear_warp_zone():
	in_warp_zone = null

func set_camera_zoom( z ):
	assert cam.is_current()
	cam.set_zoom(Vector2(z,z))

func focus_camera():
	cam.make_current()

# Flight Assist Autopilot Functions
func enable_AFA(mode):
	pass

func disable_AFA():
	pass

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



func _set_current_fuel(value):
	var new_value = clamp(value, 0, max_fuel)
	current_fuel = new_value


func _ready():
#	for dock in docks.get_children():
#		dock.owner = self
	pass

func get_forward_vector():
	var tr = get_global_transform()
	return tr.basis_xform(Vector2(0,1))

func get_left_vector():
	var tr = get_global_transform()
	return tr.basis_xform(Vector2(1,0))

func _dock_with(target,force=false):
	if docks.get_child(active_dock).touching or force:
		get_node('DockJoint').set_node_b(target.get_path())
		docked = true

func _undock_from(target):
	if docked:
		docked = false
		pending_pushoff = true

func snap_to_dock(target, dock=0):
	var T = docks.get_child(active_dock).get_ship_docked_position(target.docks.get_child(dock))
	set_global_transform(T)
	pending_dock = true
	
	
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
	
	var main_fore_vect = get_forward_vector()*delta_v_main*delta
	var rcs_fore_vect = get_forward_vector()*delta_v*delta
	var rcs_left_vect = get_left_vector()*delta_v*delta
	var yaw_rate = delta_r * delta
	
	var ct = current_thrust_force
	ct = 0
	# Do
	if pending_dock:
		_dock_with(target,true)
		pending_dock = false
	if docked:
		var T = docks.get_child(active_dock).get_ship_docked_position()
		if T != null:	state.set_transform(T)
		if controller.cmd_state.undock:
			_undock_from(target)
	if controller:
		
		# Controller Input
		var cmd = controller.cmd_state
		if cmd.thrust_pro:
			lv += main_fore_vect / get_mass()
			add_fuel(-main_fore_vect.length())
			ct += main_fore_vect.length()

		
		if cmd.thrust_retro and has_retro_thrust:
			lv -= main_fore_vect / get_mass()
			add_fuel(-main_fore_vect.length())
			ct += main_fore_vect.length()

		if cmd.rcs_pro:
			lv += rcs_fore_vect / get_mass()
			add_fuel(-rcs_fore_vect.length())
			ct += main_fore_vect.length()

		if cmd.rcs_retro:
			lv -= rcs_fore_vect / get_mass()
			add_fuel(-rcs_fore_vect.length())
			ct += main_fore_vect.length()
			
		if cmd.rcs_left:
			lv += rcs_left_vect / get_mass()
			add_fuel(-rcs_left_vect.length())
			ct += rcs_left_vect.length()
			
		if cmd.rcs_right:
			lv -= rcs_left_vect / get_mass()
			add_fuel(-rcs_left_vect.length())
			ct += rcs_left_vect.length()
			
		if cmd.yaw_left:
			av -= yaw_rate / get_mass()
			add_fuel(-yaw_rate)
			ct += yaw_rate*100
			
		if cmd.yaw_right:
			av += yaw_rate / get_mass()
			add_fuel(-yaw_rate)
			ct += yaw_rate*100
			
		if cmd.dock:
			_dock_with(target)
		if cmd.undock:
			_undock_from(target)
	current_thrust_force = ct
	current_fuel_use = ct*delta
	
	if pending_pushoff:
		pending_pushoff = false
		get_node('DockJoint').set_node_b(get_path())
		var pushoff = get_total_mass() * docks.get_child(active_dock).get_forward_vector() * 0.1
		lv = -pushoff
	# Apply Damping
	if get_linear_damp() > 0:
		lv *= 1.0-(get_linear_damp() / get_total_mass())
	if get_angular_damp() > 0:
		av *= 1.0-(get_angular_damp() / get_total_mass())
	
	# Set Velocity
	state.set_linear_velocity(lv)
	state.set_angular_velocity(av)
	docks.get_child(active_dock).get_ship_docked_position()

