
extends CanvasLayer

# 	CENTRAL HUD MOTHERNODE
#
#	Manage the function of all HUD nodes

# Game node
onready var game = get_node('/root/Game')

# Shortcuts
onready var velcon = get_node('VelCon')
onready var target = get_node('Target')
onready var colwarn = get_node('CollisionWarning')
onready var syscon = get_node('SysCon')

onready var mfdleft = get_node('box/MFDPanelLeft')
onready var mfdright = get_node('box/MFDPanelRight')

onready var pro_mark = get_node('ProMark')


#	PUBLIC METHODS

# Run the process of each hud node
# (Called by UpdateTime timeout)
func process():
#	velcon.process()
#	target.process()
#	colwarn.process()
#	syscon.process()
	if mfdleft.get_screen().has_method('process'):
		mfdleft.get_screen().call('process')
	if mfdright.get_screen().has_method('process'):
		mfdright.get_screen().call('process')



func get_player_ship_pos():
	var ship = game.get_player()
	if ship:
		var pos = ship.get_global_transform_with_canvas().get_origin()
		pos += game.get_world().get_global_pos()
		return pos
	
func get_player_ship_pro_vector():
	var ship = game.get_player()
	if ship:
		var V = ship.get_linear_velocity()
		V = V.rotated(-ship.get_rot())
		return -V


#	PRIVATE METHODS

func _ready():
	set_process(true)

func _process(delta):
	var origin = get_player_ship_pos()
	var vector = get_player_ship_pro_vector()
	pro_mark.set_pos(origin+vector)
	
	if game.get_player():
		var ship = game.get_player()
		var rot = ship.get_rot()
		get_node('box/Compass/Dial').set_rot(-rot)

# Set the zoom level of the camera
func _on_CameraZoom_value_changed( value ):
	if game.get_player():
		game.get_player().set_camera_zoom(value)


# Clock for HUD node updates
func _on_UpdateTime_timeout():
	process()