
extends Control

onready var game = get_node('/root/Game')

func get_vessel(id):
	return get_node('Vessels').get_child(id)

func get_station(id):
	return get_node('Stations').get_child(id)

func get_vessels():
	return get_node('Vessels').get_children()

func get_stations():
	return get_node('Stations').get_children()

func get_warpnodes():
	return get_node('WarpNodes').get_children()

func get_warpnode(name):
	if get_node('WarpNodes').has_node(name):
		return get_node('WarpNodes').get_node(name)

func get_warpnode_by_index(idx):
	if !get_warpnodes().empty():
		return get_node('Warpnodes').get_child(idx)

func get_object_by_name(category, name):
	if has_node(category):
		if get_node(category).has_node(name):
			return get_node(category).get_node(name)

func get_object_by_index(category, idx):
	if has_node(category):
		if get_node(category).get_child_count() > idx:
			return get_node(category).get_child(idx)

func add_vessel(vessel, position, is_player=false):
	get_node('Vessels').add_child(vessel)
	vessel.set_pos(position)
	if is_player:
		game.control.plug_in(vessel)


func remove_vessel(vessel):
	# Unplug controller if vessel is player
	if game.control.controlled == vessel:
		game.control.unplug()
	
	# Other cleaning up goes here..
	
	# Free vessel
	get_object_by_name('Vessels', vessel.get_name()).queue_free()



func add_station(station, position):
	get_node('Stations').add_child(station)
	station.set_pos(position)



func _ready():
	if game.pending_player:
		#print("GO")
		game.warp_player(self)
	set_fixed_process(true)

func _fixed_process(delta):
	if game.get_player():
		find_node('Background').parallax(game.get_player().get_global_pos())