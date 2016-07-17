
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

# Velocity force vars
export var delta_v_main = 12600.0
export var delta_v = 500.0
export var delta_r = 10.0

# Autopilot states
var auto_prograde = false
var auto_retrograde = false


var systems = {
	'mainThrust':	true,
	'RCSThrust':	true,
	'Docking':		true,
	}


#################################################
# 	CONTROLLER SIGNALS FOR SHIP FLIGHT CONTROL	#
#												#
#	(Any actions set in this ship's Controller	#
#	MUST have a function defined here. The 		#
#	function name must be identical to the 		#
#	Controller signal emitted.					#
#												#
#################################################
#	CONTROLLER SIGNAL FUNCTIONS START HERE	#
#############################################

#	PRIMARY THRUST
func thrust_pro(delta, rate=1.0):
	if systems['mainThrust']:
		var lv = get_linear_velocity()
		lv += (_get_pro_thrust()*delta)/get_total_mass()
		set_linear_velocity(lv*rate)

func thrust_retro(delta, rate=1.0):
	if systems['mainThrust']:
		var lv = get_linear_velocity()
		lv -= (_get_pro_thrust()*delta)/get_total_mass()
		set_linear_velocity(lv*rate)

#	REACTION CONTROL THRUST
func rcs_pro(delta, rate=1.0):
	if systems['RCSThrust']:
		var lv = get_linear_velocity()
		lv += (_get_rcs_forward()*delta)/get_total_mass()
		set_linear_velocity(lv*rate)

func rcs_retro(delta, rate=1.0):
	if systems['RCSThrust']:
		var lv = get_linear_velocity()
		lv -= (_get_rcs_forward()*delta)/get_total_mass()
		set_linear_velocity(lv*rate)

func rcs_left(delta, rate=1.0):
	if systems['RCSThrust']:
		var lv = get_linear_velocity()
		lv += (_get_rcs_left()*delta)/get_total_mass()
		set_linear_velocity(lv*rate)

func rcs_right(delta, rate=1.0):
	if systems['RCSThrust']:
		var lv = get_linear_velocity()
		lv -= (_get_rcs_left()*delta)/get_total_mass()
		set_linear_velocity(lv*rate)

#	YAW THRUST
func yaw_left(delta, rate=1.0):
	if systems['RCSThrust']:
		var lv = get_angular_velocity()
		lv -= (_get_rcs_yaw()*delta)/get_total_mass()
		set_angular_velocity(lv*rate)

func yaw_right(delta, rate=1.0):
	if systems['RCSThrust']:
		var lv = get_angular_velocity()
		lv += (_get_rcs_yaw()*delta)/get_total_mass()
		set_angular_velocity(lv*rate)

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
	target = world.get_node('Stations').get_child(0)


func set_camera_zoom( z ):
	assert cam.is_current()
	cam.set_zoom(Vector2(z,z))

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




func get_total_mass():
	var total = get_mass()
	return total



func dock_with_target(port=0):
	# Kill all velocity
	set_linear_velocity(Vector2(0,0))
	set_angular_velocity(0.0)
	
	# Get the angle of our docking target
	var dock_angle = dock_target.get_owner().get_rot()+dock_target.get_rot()
	
	# Snap our rotation to that of the dock
	set_rot(dock_angle)
	
	# Set dock joint to dock_target
	dock_joint.set_node_a(dock_target.get_owner().get_path())



func undock_from_target():
	var dock_body = dock_target.get_owner()
	
	# Get direction and magnitude of pushoff force
	var dir = (get_global_pos() - dock_target.get_global_pos()).normalized()
	var pushoff = dir * (get_total_mass() * 4.0)
	
	# Push off from docked vessel
	set_linear_velocity(dock_body.get_linear_velocity()+pushoff)
	set_angular_velocity((dock_body.get_angular_velocity()/dock_body.get_mass()) * get_total_mass())
	
	dock_target = null
	# set dock joint to ourself
	dock_joint.set_node_a(get_path())



# Called when we bash into something
func _on_Ship_body_enter( body ):
	var impact = (get_linear_velocity() - body.get_linear_velocity()).length()
	#hud.get_node('Impact').set_text(str(impact).pad_decimals(2))




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