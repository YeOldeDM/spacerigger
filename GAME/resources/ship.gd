
extends RigidBody2D

var controller

var dock_target = null
var docked = false
onready var dock_joint = get_node('DockJoint')

onready var dock = get_node('Dock')

onready var forward = get_node('Forward')
onready var left = get_node('Left')

export var delta_v_main = 120.0
export var delta_v = 50.0
export var delta_r = 1.0

var auto_prograde = false
var auto_retrograde = false


func _ready():
	dock.set_meta('dock',true)
	#set_fixed_process(true)


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


# DEPRICATED
#func _fixed_process(delta):
#
#	var thrust_pri = Input.is_action_pressed('thrust_primary')
#	
#	var thrust_pro = Input.is_action_pressed('thrust_pro')
#	var thrust_retro = Input.is_action_pressed('thrust_retro')
#	
#	var thrust_left = Input.is_action_pressed('thrust_left')
#	var thrust_right = Input.is_action_pressed('thrust_right')
#	
#	var yaw_left = Input.is_action_pressed('yaw_left')
#	var yaw_right = Input.is_action_pressed('yaw_right')
#	
#	var lv = get_linear_velocity()
#	var av = get_angular_velocity()
#	
#	var foreface = forward.get_global_pos() - get_global_pos()
#	var leftface = foreface.rotated(deg2rad(90))
#	
#	var pri_thrust = (foreface.normalized()*delta_v_main*delta)/get_total_mass()
#	var main_thrust = (foreface.normalized()*delta_v*delta)/get_total_mass()
#	var list_thrust = (leftface.normalized()*delta_v*delta)/get_total_mass()
#	
#	var rot_thrust = (delta_r*delta)/get_total_mass()
#	
#	if thrust_pri:
#		lv += pri_thrust
#		
#	if thrust_pro:
#		lv += main_thrust
#	if thrust_retro:
#		lv -= main_thrust
#	
#	if thrust_left:
#		lv += list_thrust
#	if thrust_right:
#		lv -= list_thrust
#	
#	if yaw_left:
#		av -= rot_thrust
#	if yaw_right:
#		av += rot_thrust
#	
#	if auto_prograde:
#		var da = get_angle_to(prograde.get_global_pos())
#		av -= da*rot_thrust
#	
#	if auto_retrograde:
#		var da = get_angle_to(retrograde.get_global_pos())
#		av -= da*rot_thrust
#	
#	if av != get_angular_velocity():
#		set_angular_velocity(av)
#	if lv != get_linear_velocity():
#		set_linear_velocity(lv)
#
#	prograde.set_global_pos(get_global_pos()+(lv.normalized()*lv.length()))
#	prograde.set_rot(get_rot())
#	retrograde.set_global_pos(get_global_pos()-(lv.normalized()*lv.length()))
#	retrograde.set_rot(get_rot())
#	
#
#	hud.get_node('Position').set_text(str(int(get_pos().x))+" : "+str(int(get_pos().y)))
#	hud.get_node('LinVel').set_text("L.V. "+str(lv.length()*0.1).pad_decimals(2)+" m/s")
#	hud.get_node('AngVel').set_text("A.V. "+str(abs(rad2deg(av))).pad_decimals(2)+" d/s")
#	
#	if dock_target:
#		set_rot(dock_target.get_rot()+deg2rad(180))
#		if Input.is_action_pressed("undock"):
#			undock_from_target()
#	
#	if Input.is_action_pressed("dock"):
#		if dock_target:
#			set_linear_velocity(Vector2(0,0))
#			set_angular_velocity(0.0)
#			dock_with_target()

func get_total_mass():
	var total = get_mass()
	return total

func dock_with_target(port=0):
	dock_joint.set_node_a(dock_target.get_path())

func undock_from_target():
	var dir = (get_global_pos() - dock_target.get_node('Dock').get_global_pos()).normalized()
	
	var pushoff = dir*(get_total_mass()*5)
	set_angular_velocity(dock_target.get_angular_velocity())
	set_linear_velocity(dock_target.get_linear_velocity()+pushoff)
	dock_target = null
	dock_joint.set_node_a(get_path())




func _on_Ship_body_enter( body ):
	var impact = (get_linear_velocity() - body.get_linear_velocity()).length()
	#hud.get_node('Impact').set_text(str(impact).pad_decimals(2))



func _on_Dock_area_enter( area ):
	if area.has_meta('dock'):
		if area.get_meta('dock'):
			dock.get_node('Light').set_color(Color(0,1,0))
			dock_target = area.get_owner()
			



func _on_Dock_area_exit( area ):
	if dock.get_node('Light').get_color() != Color(1,0,0):
		dock.get_node('Light').set_color(Color(1,0,0))
		dock_target = null
