
extends PanelContainer

#	VELOCITY CONTROL HUD NODE
#
#	Controls and displays ship velocity info
#
#

# Game node
onready var game = get_node('/root/Game')
onready var hud = game.hud


# Shortcuts
onready var velcon = get_node('box')
onready var output = velcon.get_node('Output')
onready var linvel = output.get_node('Lin')
onready var angvel = output.get_node('Rot')
onready var linvalue = linvel.get_node('Speed/Value')
onready var angvalue = angvel.get_node('Speed/Value')
onready var vel_origin = velcon.get_node('Origin/Switch')



# Mainloop
func process():
	if hud.get_player_ship():
		# Get controlled ship
		var s = hud.get_player_ship()

		# Get velocity values
		var lv = s.get_linear_velocity()
		var av = s.get_angular_velocity()
		# Get target-relative velocity if TVR is enabled
		if vel_origin.is_pressed() and s.target:
			var t = s.target
			lv = t.get_linear_velocity() - lv
			av = t.get_angular_velocity() - av

		# Display velocity values
		linvalue.set_text(str(lv.length()*0.1).pad_decimals(2))
		angvalue.set_text(str(abs(rad2deg(av))).pad_decimals(2))


