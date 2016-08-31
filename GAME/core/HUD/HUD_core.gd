
extends CanvasLayer

# 	CENTRAL HUD MOTHERNODE
#
#	Manage the function of all HUD nodes

# Game node
onready var game = get_node('/root/Game')

# Shortcuts
onready var top = get_node('box/TopBar')
onready var clock = top.get_node('Clock')
onready var camzoom = top.get_node('CameraZoom')
onready var power_control = get_node('box/PowerControl')

onready var fuel = get_node('box/Fuel')

onready var warp = get_node('box/WarpControl')

onready var mfdleft = get_node('box/MFDPanelLeft')
onready var mfdright = get_node('box/MFDPanelRight')
var default_mfd_programs = ['loc', 'linang']

onready var pro_mark = get_node('ProMark')


#	PUBLIC METHODS

# Dumb process for updating HUD elements
func process():


	clock.process()
	fuel.process()
	#warp.process()
	
	if mfdleft.get_screen().has_method('process'):
		mfdleft.get_screen().call('process')
	if mfdright.get_screen().has_method('process'):
		mfdright.get_screen().call('process')
# Clock for HUD node updates
func _on_UpdateTime_timeout():
	# Call dumb process
	process()



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
		SoundMan.play('click')
	# get camera and set zoom
	var ship = game.get_player()
	if ship:
		ship.cam.set_zoom(Vector2(value,value))



#	PRIVATE METHODS

func _ready():
	if top.has_node('CameraZoom'):
		top.get_node('CameraZoom/box/Slider').connect("changed",self,"set_camera_zoom")
		top.get_node('CameraZoom/box/1x').connect("pressed",self,"set_camera_zoom",[1.0, true])
	
	mfdleft.set_screen(default_mfd_programs[0])
	mfdright.set_screen(default_mfd_programs[1])
	
	set_process(true)

	get_node('SamplePlayer').play('radiator')
	




# Actual process. Used for things that update in realtime.
func _process(delta):
	
	if game.get_player():
		place_prograde_marker()
		var ship = game.get_player()
		var rot = ship.get_rot()
		get_node('box/Compass/Dial').set_rot(-rot)


func place_prograde_marker():
	var origin = get_player_ship_pos()
	var vector = get_player_ship_pro_vector()
	var vl = vector.length()
	vector = vector.normalized()*min(vl,200)
	pro_mark.set_pos(origin+vector)
	pro_mark.get_node('Arrow').look_at(origin)
	pro_mark.get_node('Velocity').set_text(str(vl*0.1).pad_decimals(2)+" m/s")
	

