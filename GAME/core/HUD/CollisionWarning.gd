
extends PanelContainer

const ON = Color(1,0,0)
const OFF = Color(0.2,0.2,0.2)

onready var game = get_node('/root/Game')

onready var text = get_node('box/Label')
onready var cast_range = get_node('box/SpinBox')


func process():
	if game.control.ship:
		var s = game.control.ship
		var cd = cast_range.get_value()
		var world = s.world.get_world_2d().get_direct_space_state()
		var ray_point = s.get_global_pos()+(s.get_linear_velocity() * cd)
		var rayhit = world.intersect_ray(s.get_global_pos(), ray_point, [s])
		if !rayhit.empty():
			text.set('custom_colors/font_color', ON)
			var D = rayhit['position'].distance_to(s.get_global_pos())
			D = str(D/s.get_linear_velocity().length()).pad_decimals(2)
			text.set_text("Collision in "+D+" s")
		else:
			text.set('custom_colors/font_color', OFF)
			text.set_text("No Collision Warning")


