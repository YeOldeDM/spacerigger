
extends TabContainer

onready var space = get_node('Space')
onready var control = space.get_node('Control')


func _ready():
	var ship = space.get_node('Viewport/World/Ship')
	control.connect_to(ship)


func _draw():
	draw_string(preload('res://assets/fonts/hack14.fnt'),\
			Vector2(16,8), "Space Rigger Alpha")