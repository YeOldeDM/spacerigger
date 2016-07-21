
extends TabContainer

const GAME_NAME = "Space Rigger Alpha"

onready var space = get_node('Space')
onready var control = space.get_node('Control')
onready var hud = control.get_node('HUD')

# might not want this: get ship ref from control
onready var player_ship = space.get_node('Viewport/World/Vessels/Ship')
onready var other_ship = space.get_node('Viewport/World/Vessels/Ship 2')

onready var help = space.get_node('Help')

func _ready():
	control.plug_in(player_ship)
	hud.get_node('SysCon').init()


func _draw():
	draw_string(preload('res://assets/fonts/hack14.fnt'),\
			Vector2(16,8), GAME_NAME)




func _on_helpbutton_pressed():
	help.popup_centered()





func _on_switchships_pressed():
	control.disconnect_from(player_ship)
	control.connect_to(other_ship)


func _on_Game_tab_changed( tab ):
	if get_child(tab).get_name() == "Pedia":
		get_node('Pedia/PediaWindow').popup_centered()



