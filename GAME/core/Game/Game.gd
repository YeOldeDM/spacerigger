
extends Control

const GAME_NAME = "Space Rigger Alpha"

const EPOCH = 883613904

var Time = 0

#onready var space = get_node('Space')
onready var control = get_node('Controller')
onready var world = get_node('World')
onready var hud = get_node('HUD')


func get_player():
	if control.controlled:
		return control.controlled

func get_world():
	if !world.get_children().empty():
		return world.get_child(0)

func _ready():
	var init_world = Spawn.world('test_world')
	world.add_child(init_world)
	
	Time = EPOCH
	
	var player_ship = Spawn.ship('Tauro')
	get_world().add_vessel(player_ship, Vector2(0,0), true)

	# Start maximized
	OS.set_window_maximized(true)
	set_process(true)

func _process(delta):
	Time += delta	# tick forward Time

#func _draw():
#	draw_string(preload('res://assets/fonts/hack14.fnt'),\
#			Vector2(16,8), GAME_NAME)




#func _on_helpbutton_pressed():
#	help.popup_centered()





#func _on_switchships_pressed():
#	control.disconnect_from(player_ship)
#	control.connect_to(other_ship)
#
#



