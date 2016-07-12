
extends TabContainer

const GAME_NAME = "Space Rigger Alpha"

onready var space = get_node('Space')
onready var control = space.get_node('Control')

onready var player_ship = space.get_node('Viewport/World/Vessels/Ship')

onready var help = space.get_node('Help')

func _ready():
	control.connect_to(player_ship)


func _draw():
	draw_string(preload('res://assets/fonts/hack14.fnt'),\
			Vector2(16,8), GAME_NAME)




func _on_helpbutton_pressed():
	help.popup_centered()
