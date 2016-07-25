
extends Control

const GAME_NAME = "Space Rigger Alpha"
const EPOCH = 889963900

var Time = 0

#onready var space = get_node('Space')
onready var control = get_node('Controller')
onready var world = get_node('World')
onready var hud = get_node('HUD')


#	PUBLIC METHODS

func get_player():
	if control.controlled:
		return control.controlled

func get_world():
	if !world.get_children().empty():
		return world.get_child(0)
	else:
		return null

func change_world(world_name, target_node, offset=Vector2(1000,1000)):
	var new_world = load('res://res/worlds/'+world_name+'.tscn')
	if new_world:
		var old_world = get_world()
		if old_world:
			old_world.queue_free()
		new_world = new_world.instance()
		world.add_child(new_world)
		var node = new_world.get_warpnodes().find_node(target_node)
		var player_ship = Spawn.ship(InitShip)
		new_world.add_vessel(player_ship, node.get_pos()+offset)
	else:
		OS.alert("No such world as "+world_name)




#	PRIVATE METHODS

var InitShip = 'EVAsuit'

func _ready():
	var init_world = Spawn.world('test_world')
	world.add_child(init_world)
	
	Time = EPOCH
	
	var player_ship = Spawn.ship(InitShip)
	get_world().add_vessel(player_ship, Vector2(0,0), true)
	player_ship.refuel()

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



