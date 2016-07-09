
extends CanvasLayer

onready var game = get_node('/root/Game')

onready var velcon = get_node('VelCon')
onready var target = get_node('Target')


func _ready():
	set_process(true)

func process():
	velcon.process()
	target.process()



func _on_CameraZoom_value_changed( value ):
	if game.control.ship:
		game.control.ship.set_camera_zoom(value)


func _on_UpdateTime_timeout():
	process()
