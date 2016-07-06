
extends Control

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process(true)

func _process(delta):
	pass

func _draw():
	draw_circle(Vector2(200,200), 6, Color(1,1,1))


