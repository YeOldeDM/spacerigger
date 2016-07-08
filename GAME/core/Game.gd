
extends TabContainer

onready var space = get_node('Space')
onready var control = space.get_node('Control')

onready var player_ship = space.get_node('Viewport/World/Ship')

func _ready():
	control.connect_to(player_ship)


func _draw():
	draw_string(preload('res://assets/fonts/hack14.fnt'),\
			Vector2(16,8), "Space Rigger Alpha")

func _on_CameraZoom_value_changed( value ):
	player_ship.zoom_camera(value)
