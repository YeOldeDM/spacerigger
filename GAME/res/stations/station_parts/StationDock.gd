
extends Sprite

onready var point_a = get_node('PointA')
onready var point_b = get_node('PointB')

var owner

var cleared_for = null
var open = true

var touched_in = false

var touchin = { 0:false, 1:false }

export var dock_name = "Alpha"



func get_direction_vector():
	var V = get_node('Forward').get_global_pos() - get_global_pos()
	return V.normalized()

func get_positional_vectors():
	var V = [point_a.get_global_pos(), point_b.get_global_pos()]

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

func _on_Point_area_exit(area, dockpoint):
	if area.has_meta('dockpoint'):
		touchin[dockpoint] = false
		_check_for_touchin()


func _check_for_touchin():
	if touchin[0]==true and touchin[1]==true:
		if not touched_in:
			touched_in = true
			_shoot_steam()

	else:	
		touched_in = false
		_stop_steam()
