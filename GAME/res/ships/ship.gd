
extends RigidBody2D

#	SHIP BODY NODE
#	



# World node
onready var world = get_node('../../')

# Shortcuts
onready var thrusters = get_node('thrust_emitters')
onready var dock_joint = get_node('DockJoint')
onready var dock = get_node('Dock')
onready var forward = get_node('Forward')
onready var left = get_node('Left')
onready var cam = get_node('Camera')

# Controller node
# (set by Controller)
var controller

# Current Target
var target = null

# Current Docking Target
var dock_target = null
# Docked state
var docked = false
# Dock zones touching state
var in_dock_zone = false

export var shipID = "A1A-2"
# Velocity force vars
export var delta_v_main = 1260.0
export var delta_v = 500.0
export var delta_r = 5.0

export var rcs_config_I = true

export var has_main_thrust = true
export var has_rcs_thrust = true
export var has_warp_drive = true

export var max_fuel = 16.0
var current_fuel = 0

# Autopilot states
var auto_prograde = false
var auto_retrograde = false


var systems = {
	'mainThrust':	true,
	'RCSThrust':	true,
	'Docking':		true,
	}


func process(delta, cmd_state):
	
	set_thruster_emission(cmd_state)
	
	for act in cmd_state:
		if cmd_state[act] == true:
			if has_method(act):
				call(act,delta)
			else:
				print("No such thing as Action: "+act)
#################################################
# 	CONTROLLER SIGNALS FOR SHIP FLIGHT CONTROL	#
#												#
#################################################
#	CONTROLLER SIGNAL FUNCTIONS START HERE	#
#############################################

#	PRIMARY THRUST
func thrust_pro(delta ):
	if has_main_thrust:
		if systems['mainThrust']:
			_thrust(_get_pro_thrust()*delta)


func thrust_retro(delta ):
	if has_main_thrust:
		if systems['mainThrust']:
			_thrust(-_get_pro_thrust()*delta)


#	REACTION CONTROL THRUST
func rcs_pro(delta ):
	if has_rcs_thrust:
		if systems['RCSThrust']:
			_thrust(_get_rcs_forward()*delta)


func rcs_retro(delta ):
	if has_rcs_thrust:
		if systems['RCSThrust']:
			_thrust(-_get_rcs_forward()*delta)


func rcs_left(delta ):
	if has_rcs_thrust:
		if systems['RCSThrust']:
			_thrust(_get_rcs_left()*delta)


func rcs_right(delta ):
	if has_rcs_thrust:
		if systems['RCSThrust']:
			_thrust(-_get_rcs_left()*delta)

#	YAW THRUST
func yaw_left(delta ):
	if has_rcs_thrust:
		if systems['RCSThrust']:
			_yaw(-_get_rcs_yaw()*delta)


func yaw_right(delta ):
	if has_rcs_thrust:
		if systems['RCSThrust']:
			_yaw(_get_rcs_yaw()*delta)



#	DOCK/UNDOCK
func dock(delta):
	if systems['Docking']:
		if in_dock_zone:
			dock_with_target()
			docked = true

func undock(delta):
	if systems['Docking']:
		if docked:
			docked = false
			undock_from_target()



#########################################
#	END OF CONTROLLER SIGNAL FUNCTIONS	#
#########################################

func _ready():
	dock.set_meta('dock',true)
	target = world.get_node('WarpNodes').get_child(0)



func set_camera_zoom( z ):
	assert cam.is_current()
	cam.set_zoom(Vector2(z,z))


func set_thruster_emission(cmd_state):
	var thr = {}
	for i in thrusters.get_children():
		thr[i.get_name()] = false
	

	if cmd_state['thrust_pro'] == true:
		 thr['ProThrustR'] = true
		 thr['ProThrustL'] = true
	
	if cmd_state['thrust_retro'] == true:
		 thr['RetroThrustR'] = true
		 thr['RetroThrustL'] = true


	if cmd_state['rcs_pro'] == true:
		 thr['RCSProR'] = true
		 thr['RCSProL'] = true
	
	if cmd_state['rcs_retro'] == true:
		 thr['RCSRetroR'] = true
		 thr['RCSRetroL'] = true

	if cmd_state['rcs_left'] == true:
		 thr['RCSRightF'] = true
		 thr['RCSRightA'] = true

	if cmd_state['rcs_right'] == true:
		 thr['RCSLeftF'] = true
		 thr['RCSLeftA'] = true


	if cmd_state['yaw_left'] == true:
		if rcs_config_I:
			thr['RCSRightF'] = true
			thr['RCSLeftA'] = true
		else:
			thr['RCSProR'] = true
			thr['RCSRetroL'] = true

	if cmd_state['yaw_right'] == true:
		if rcs_config_I:
			thr['RCSLeftF'] = true
			thr['RCSRightA'] = true
		else:
			thr['RCSProL'] = true
			thr['RCSRetroR'] = true
			

	for key in  thr:
		if  thr[key] == true:
			if not thrusters.get_node(key).is_emitting():
				thrusters.get_node(key).set_emitting(true)

		else:
			if thrusters.get_node(key).is_emitting():
				thrusters.get_node(key).set_emitting(false)


# Get thrust vectors
func _get_forefacing():
	return forward.get_global_pos() - get_global_pos()

func _get_leftfacing():
	return left.get_global_pos() - get_global_pos()

func _get_pro_thrust():
	return _get_forefacing().normalized()*delta_v_main

func _get_rcs_forward():
	return _get_forefacing().normalized()*delta_v

func _get_rcs_left():
	return _get_leftfacing().normalized()*delta_v

func _get_rcs_yaw():
	return delta_r

func refuel():
	current_fuel = max_fuel

func has_fuel(amt):
	if current_fuel >= amt:
		return true
	return false

func _eat_fuel(amt):
	amt *= 0.1
	var new_fuel = clamp(current_fuel-amt, 0, max_fuel)
	current_fuel = new_fuel
	


func _thrust(vector):
	var fuel_amt = vector.length()/1000.0
	if has_fuel(fuel_amt):
		var lv = get_linear_velocity()
		lv += vector / get_total_mass()
		set_linear_velocity(lv)
		_eat_fuel(fuel_amt)
		get_node('Camera').apply_shake(fuel_amt*0.45)

func _yaw(force):
	var fuel_amt = (rad2deg(abs(force))*1.75)/1000.0
	print(fuel_amt)
	if has_fuel(fuel_amt):
		var av = get_angular_velocity()
		av += force / get_total_mass()
		set_angular_velocity(av)
		_eat_fuel(fuel_amt)
		get_node('Camera').apply_shake(fuel_amt*0.45)




func focus_camera():
	get_node('Camera').make_current()



func get_total_mass():
	var total = get_mass()
	return total




func dock_with_target(port=0):
	# Kill all velocity
	set_linear_velocity(Vector2(0,0))
	set_angular_velocity(0.0)
	
	# Get the angle of our docking target
	var dock_angle = dock_target.get_owner().get_rot()+dock_target.get_rot()
	dock_angle -= get_node('Dock').get_rot()
	# Snap our rotation to that of the dock
	#set_rot(dock_angle)
	
	# Set dock joint to dock_target
	dock_joint.set_node_a(dock_target.get_owner().get_path())



func undock_from_target():
	var dock_body = dock_target.get_owner()
	
	# Get direction and magnitude of pushoff force

	var dir = (get_node('Dock').get_global_pos() - get_global_pos())
	var pushoff = dir.normalized() * get_total_mass()
	
	
	# Push off from docked vessel
	set_linear_velocity(-pushoff+dock_body.get_linear_velocity())
	#set_angular_velocity((dock_body.get_angular_velocity()/dock_body.get_mass()) * get_total_mass())
	
	dock_target = null
	# set dock joint to ourself
	dock_joint.set_node_a(get_path())



func sync_rot_with_dock():
	var dock_body = dock_target.get_owner()
	var t_rot = dock_body.get_rot()
	var d_rot = get_node('Dock').get_rot()
	set_rot(t_rot-d_rot+PI)



# Called when we bash into something
func _on_Ship_body_enter( body ):
	pass




func _set_dock_viz(state=false):
	if state == true:
		# Greenlight!
		dock.get_node('Light').set_color(Color(0,1,0))
	else:
		# Redlight!
		dock.get_node('Light').set_color(Color(1,0,0))



# Our Dock area is touching another Dock area
func _on_Dock_area_enter( area ):
	if area.has_meta('dock'):
		if area.get_meta('dock'):
			_set_dock_viz(true)
			dock_target = area
			in_dock_zone = true
			


# Our Dock area leaves another Dock area
func _on_Dock_area_exit( area ):
	if in_dock_zone:
		_set_dock_viz(false)
		dock_target = null
		in_dock_zone = false