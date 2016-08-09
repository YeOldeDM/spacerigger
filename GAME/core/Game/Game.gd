
extends Control

const GAME_NAME = "Space Rigger Alpha"
const EPOCH = 889963900

export var start_engines = true


var Time = 0
var stopwatch_time = 0
var stopwatch_running = false

#onready var space = get_node('Space')
onready var control = get_node('Controller')
onready var world = get_node('World')
onready var hud = get_node('HUD')
onready var context = get_node('Context')
onready var pedia = context.get_node('PediaWindow')

var temp_ship

var temp_node
var temp_offset
var temp_angle_diff
var temp_linvel
var temp_angvel
var pending_player = false

#	PUBLIC METHODS

func get_player():
	if control.controlled:
		return control.controlled

func get_world():
	if world and !world.get_children().empty():
		return world.get_child(0)
	else:
		return null


func change_world(world_name):
	var new_world = load('res://res/worlds/'+world_name+'.tscn')
	if new_world:
		print(new_world)
		get_player().controller.unplug()
		var old_world = get_world()
		if old_world:
			old_world.queue_free()
		new_world = new_world.instance()
		world.add_child(new_world)
	else:
		OS.alert("No such world as "+world_name)

func warp_player(destination):
	var node = destination.get_warpnode(temp_node)
	var player_ship = Spawn.ship(InitShip)
	var pos = node.get_global_pos()
	destination.add_vessel(player_ship, pos+temp_offset, true)
	var z = hud.camzoom.get_node('box/Slider').get_value()
	player_ship.set_camera_zoom(z)
	
	player_ship.current_fuel = temp_ship['current_fuel']
	player_ship.set_rot(temp_angle_diff - node.get_rot())
	player_ship.set_linear_velocity(temp_linvel)
	player_ship.set_angular_velocity(temp_angvel)
	pending_player = false
	temp_node = null
	temp_offset = null
	temp_linvel = null
	temp_angvel = null
	temp_angle_diff = null
	temp_ship = null
	print(player_ship.has_main_thrust)

func pedia(entry=null):
	_show_pedia(entry)



#	PRIVATE METHODS

var InitShip = 'Tauro'

func _ready():
	_kill_ui_binds()
	
	var init_world = Spawn.world('test_world')
	world.add_child(init_world)
	
	Time = EPOCH
	
	var player_ship = Spawn.ship(InitShip)
	get_world().add_vessel(player_ship, Vector2(4000,-4000), true)
	player_ship.refuel()

	# Start maximized
	#OS.set_window_maximized(true)
	set_process(true)

func _process(delta):
	Time += delta	# tick forward Time
	
	if stopwatch_running:
		stopwatch_time += delta


func _kill_ui_binds():
	var space = InputEvent()
	space.type = InputEvent.KEY
	space.scancode = KEY_SPACE
	InputMap.action_erase_event('ui_accept', space)
	InputMap.action_erase_event('ui_select', space)


func _show_pedia(entry='welcome'):
	pedia.current_entry = entry
	pedia.popup_centered()

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


func click():
	SoundMan.play('click')

func _on_Warp_pressed():
	click()
	var ship = get_player()
	if !ship:
		return null
	if ship.in_warp_zone:
		var warpnode = ship.in_warp_zone
		var offset = warpnode.get_pos() - ship.get_pos()
		var dest = warpnode.destination
		var target = warpnode.target_node
		
		if dest != "None" and target != "None":
			temp_node = target
			temp_offset = offset
			temp_angle_diff =  ship.get_rot() - warpnode.get_rot()
			temp_linvel = ship.get_linear_velocity()
			temp_angvel = ship.get_angular_velocity()
			temp_ship = inst2dict(ship)
			pending_player = true
			change_world(dest)
			#OS.alert("Your Warp Drive controls are blocked by a mysterious force..",\
					#"Fire the Programmer!")
			pass


func _on_Pedia_pressed():
	click()
	context.get_node('PediaWindow').popup_centered()
