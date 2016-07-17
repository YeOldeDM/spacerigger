
extends PanelContainer

#	COLLISION DETECTION SYSTEM HUD NODE
#
#	Casts a ray along the ship's current flight
#	vector and reports countdown to collision.


# Text Colors
const ON = Color(1,0,0)
const OFF = Color(0.2,0.2,0.2)

# Game node
onready var game = get_node('/root/Game')
onready var hud = game.hud

# Shortcuts
onready var text = get_node('box/Label')
onready var cast_range = get_node('box/SpinBox')


# Mainloop
func process():
	if hud:
		
		# Get controlled ship
		var s = hud.get_player_ship()
		# Get raycast range (in seconds)
		var cd = cast_range.get_value()
		
		# Cast the ray (current LVnormalized * cast range)
		var world = s.world.get_world_2d().get_direct_space_state()
		var ray_point = s.get_global_pos()+(s.get_linear_velocity() * cd)
		# Report from raycast
		var rayhit = world.intersect_ray(s.get_global_pos(), ray_point, [s])
		
		# if there is a hit..
		if not rayhit.empty():
			text.set('custom_colors/font_color', ON)
			# Get distance
			var D = rayhit['position'].distance_to(s.get_global_pos())
			# Calculate countdown time
			D = str(D/s.get_linear_velocity().length()).pad_decimals(2)
			# Set warning text
			text.set_text("Collision in "+D+" s")
		else:
			# No collision warning..
			text.set('custom_colors/font_color', OFF)
			text.set_text("No Collision Warning")


