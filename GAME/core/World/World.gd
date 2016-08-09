
extends Control

onready var game = get_node('/root/Game')



func get_vessels():
	return get_node('Vessels').get_children()

func get_stations():
	return get_node('Stations').get_children()

func get_warpnodes():
	return get_node('WarpNodes').get_children()

func get_warpnode(name):
	return get_node('WarpNodes').get_node(name)

func get_warpnode_by_index(idx):
	if !get_warpnodes().empty():
		return get_node('Warpnodes').get_child(idx)

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
	get_node('Vessels/'+vessel.get_name()).queue_free()



func add_station(station, position):
	get_node('Stations').add_child(station)
	station.set_pos(position)



func _ready():
	if game.pending_player:
		#print("GO")
		game.warp_player(self)