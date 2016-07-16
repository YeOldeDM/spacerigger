
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



# Run the process of each hud node
# (Called by UpdateTime timeout)
func process():
	velcon.process()
	target.process()
	colwarn.process()
	syscon.process()



# Set the zoom level of the camera
func _on_CameraZoom_value_changed( value ):
	if game.control.ship:
		game.control.ship.set_camera_zoom(value)


# Clock for HUD node updates
func _on_UpdateTime_timeout():
	process()
