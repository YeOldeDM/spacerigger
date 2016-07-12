
extends RigidBody2D

var controller

onready var world = get_node('../../')


onready var thrusters = get_node('thrust_emitters')

var target = null

var dock_target = null
var docked = false
onready var dock_joint = get_node('DockJoint')

onready var dock = get_node('Dock')

onready var forward = get_node('Forward')
onready var left = get_node('Left')

onready var cam = get_node('Camera')

export var delta_v_main = 12600.0
export var delta_v = 500.0
export var delta_r = 10.0

var auto_prograde = false
var auto_retrograde = false


func _ready():
	dock.set_meta('dock',true)
	target = world.get_node('Stations').get_child(0)


func set_camera_zoom( z ):
	assert cam.is_current()
	cam.set_zoom(Vector2(z,z))

func thrust_pro(delta):
	var lv = get_linear_velocity()
	lv += (_get_pro_thrust()*delta)/get_total_mass()
	set_linear_velocity(lv)

func thrust_retro(delta):
	var lv = get_linear_velocity()
	lv -= (_get_pro_thrust()*delta)/get_total_mass()
	set_linear_velocity(lv)

func rcs_pro(delta):
	var lv = get_linear_velocity()
	lv += (_get_rcs_forward()*delta)/get_total_mass()
	set_linear_velocity(lv)

func rcs_retro(delta):
	var lv = get_linear_velocity()
	lv -= (_get_rcs_forward()*delta)/get_total_mass()
	set_linear_velocity(lv)

func rcs_left(delta):
	var lv = get_linear_velocity()
	lv += (_get_rcs_left()*delta)/get_total_mass()
	set_linear_velocity(lv)

func rcs_right(delta):
	var lv = get_linear_velocity()
	lv -= (_get_rcs_left()*delta)/get_total_mass()
	set_linear_velocity(lv)

func yaw_left(delta):
	var lv = get_angular_velocity()
	lv -= (_get_rcs_yaw()*delta)/get_total_mass()
	set_angular_velocity(lv)

func yaw_right(delta):
	var lv = get_angular_velocity()
	lv += (_get_rcs_yaw()*delta)/get_total_mass()
	set_angular_velocity(lv)

func dock(delta):
	if dock_target:
		dock_with_target()
		docked = true

func undock(delta):
	if docked:
		docked = false
		undock_from_target()

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
	set_linear_velocity(Vector2(0,0))
	set_angular_velocity(0.0)
	var dock_angle = dock_target.get_owner().get_rot()+dock_target.get_rot()
	print(dock_angle)
	set_rot(dock_angle)
	#set_rot(dock_target.get_rot())
	# Set dock joint to dock_target
	dock_joint.set_node_a(dock_target.get_owner().get_path())

func undock_from_target():
	var dir = (get_global_pos() - dock_target.get_global_pos()).normalized()
	var pushoff = dir * (get_total_mass() * 8.0)
	set_angular_velocity(dock_target.get_owner().get_angular_velocity())
	set_linear_velocity(dock_target.get_owner().get_linear_velocity()+pushoff)
	dock_target = null
	# set dock joint to ourself
	dock_joint.set_node_a(get_path())




func _on_Ship_body_enter( body ):
	var impact = (get_linear_velocity() - body.get_linear_velocity()).length()
	#hud.get_node('Impact').set_text(str(impact).pad_decimals(2))



func _on_Dock_area_enter( area ):
	if area.has_meta('dock'):
		if area.get_meta('dock'):
			dock.get_node('Light').set_color(Color(0,1,0))
			dock_target = area
			



func _on_Dock_area_exit( area ):
	if dock.get_node('Light').get_color() != Color(1,0,0):
		dock.get_node('Light').set_color(Color(1,0,0))
		dock_target = null
