
extends Sprite

onready var point_a = get_node('PointA')
onready var point_b = get_node('PointB')

var owner


var cleared_for = null
var open = true

var touched_in = false
var touching = null

var touchin = { 0:false, 1:false }

export var dock_name = "Alpha"

func get_forward_vector():
	var trans = get_global_transform()
	return trans.basis_xform(Vector2(0,1))

func get_direction_deviation(target):
	var t_dir = target.get_forward_vector().rotated(deg2rad(180))
	return get_forward_vector().angle_to(t_dir)
	
func get_positional_deviation(target):
	var t_pos = target.get_positional_vectors()
	var o_pos = get_positional_vectors()
	var out = [(o_pos[0]-t_pos[1]).length(), (o_pos[1]-t_pos[0]).length()]
	return out


func get_positional_vectors():
	var V = [point_a.get_global_pos(), point_b.get_global_pos()]
	return V

func get_heading():
	assert owner
	return owner.get_rot()+get_rot()

func _ready():
	point_a.set_meta('dockpoint', 0)
	point_a.connect("area_enter", self, '_on_Point_area_enter', [0])
	point_a.connect("area_exit", self, '_on_Point_area_exit', [0])
	
	point_b.set_meta('dockpoint', 1)
	point_b.connect("area_enter", self, '_on_Point_area_enter', [1])
	point_b.connect("area_exit", self, '_on_Point_area_exit', [1])


func _shoot_steam():
	get_node('SteamLeft').set_emitting(true)
	get_node('SteamRight').set_emitting(true)

func _stop_steam():
	get_node('SteamLeft').set_emitting(false)
	get_node('SteamRight').set_emitting(false)

func _on_Point_area_enter(area, dockpoint):
	if area.has_meta('dockpoint'):
		if area.get_meta('dockpoint') == abs(dockpoint-1):
			touchin[dockpoint] = true
			_check_for_touchin()
	if touching != area:
		touching = area

func _on_Point_area_exit(area, dockpoint):
	if area.has_meta('dockpoint'):
		touchin[dockpoint] = false
		_check_for_touchin()
	if touching == area:
		touching = null


func _check_for_touchin():
	if touchin[0]==true and touchin[1]==true:
		if not touched_in:
			touched_in = true
			_shoot_steam()

	else:	
		touched_in = false
		_stop_steam()
