
extends CanvasLayer

# 	CENTRAL HUD MOTHERNODE
#
#	Manage the function of all HUD nodes

# Game node
onready var game = get_node('/root/Game')

# Shortcuts
onready var top = get_node('box/TopBar')
onready var clock = top.get_node('Clock')

onready var fuel = get_node('box/Fuel')

onready var warp = get_node('box/WarpControl')

onready var mfdleft = get_node('box/MFDPanelLeft')
onready var mfdright = get_node('box/MFDPanelRight')

onready var pro_mark = get_node('ProMark')


#	PUBLIC METHODS

# Dumb process for updating HUD elements
func process():


	clock.process()
	fuel.process()
	warp.process()
	
	if mfdleft.get_screen().has_method('process'):
		mfdleft.get_screen().call('process')
	if mfdright.get_screen().has_method('process'):
		mfdright.get_screen().call('process')


# Get player ship position on canvas
func get_player_ship_pos():
	var ship = game.get_player()
	if ship:
		var pos = ship.get_global_transform_with_canvas().get_origin()
		pos += game.get_world().get_global_pos()
		return pos

# Get ship prograde vector on canvas
func get_player_ship_pro_vector():
	var ship = game.get_player()
	if ship:
		var V = ship.get_linear_velocity()
		V = V.rotated(-ship.get_rot())
		return -V

# Set zoom level of the ship camera
func set_camera_zoom( value, from_outside=false ):
	# if from outside the slider, set the slider to match value
	if from_outside:
		top.get_node('CameraZoom/box/Slider').set_value(value)
	# get camera and set zoom
	var ship = game.get_player()
	if ship:
		ship.cam.set_zoom(Vector2(value,value))



#	PRIVATE METHODS

func _ready():
	if top.has_node('CameraZoom'):
		top.get_node('CameraZoom/box/Slider').connect("changed",self,"set_camera_zoom")
		top.get_node('CameraZoom/box/1x').connect("pressed",self,"set_camera_zoom",[1.0, true])
	
	set_process(true)

# Actual process. Used for things that update in realtime.
func _process(delta):
	var origin = get_player_ship_pos()
	var vector = get_player_ship_pro_vector()
	pro_mark.set_pos(origin+vector)
	
	if game.get_player():
		var ship = game.get_player()
		var rot = ship.get_rot()
		get_node('box/Compass/Dial').set_rot(-rot)




# Clock for HUD node updates
func _on_UpdateTime_timeout():
	# Call dumb process
	process()