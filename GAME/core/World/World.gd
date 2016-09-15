
extends Control

# Game object
onready var game = get_node('/root/Game')



#####################
#	PUBLIC METHODS	#


# Get all Vessels
func get_vessels():
	return get_node('Vessels').get_children()

# Get all Stations
func get_stations():
	return get_node('Stations').get_children()

# Get all WarpNodes
func get_warpnodes():
	return get_node('WarpNodes').get_children()


# Get object 'name' in 'category'
# Categories are: "Vessels", "Stations", "WarpNodes"
func get_object_by_name(category, name):
	if has_node(category):
		if get_node(category).has_node(name):
			return get_node(category).get_node(name)

# Get object at index 'idx' in 'category'
func get_object_by_index(category, idx):
	if has_node(category):
		if get_node(category).get_child_count() > idx:
			return get_node(category).get_child(idx)



# Add 'vessel' to the World at 'position'
# is_player flag will plug in the controller
# (vessel is instanced through Spawn singleton)
func add_vessel(vessel, position, is_player=false):
	get_node('Vessels').add_child(vessel)
	vessel.set_pos(position)
	if is_player:
		game.control.plug_in(vessel)

# Remove 'vessel' from the World
func remove_vessel(vessel):
	# Unplug controller if vessel is player
	if game.control.controlled == vessel:
		game.control.unplug()
	
	# Other cleaning up goes here..
	
	# Free vessel
	get_object_by_name('Vessels', vessel.get_name()).queue_free()


# Add 'station' to World at 'position'
# (station is instanced through Spawn singleton)
func add_station(station, position):
	get_node('Stations').add_child(station)
	station.set_pos(position)






#########################
#	PRIVATE METHODS		#


func _ready():
	if game.pending_player:
		#print("GO")
		game.warp_player(self)
	set_fixed_process(true)

func _fixed_process(delta):
	if game.get_player():
		find_node('Background').parallax(game.get_player().get_global_pos())