
extends Position2D

onready var main = get_node('/root/Main')

func _ready():
	set_process(true)

func _process(delta):
	# apply ship rotation to radar rotation
	set_rot(-main.ship.get_rot())
	update()

func _draw():
	for body in main.get_node('Bodies').get_children():
		# get body position relative to ship
		var pos = (main.ship.get_global_pos() - body.get_global_pos())*0.0091
		# get opacity based on distance
		var O = clamp(pos.length()/200, 0.0, 1.0)
		# draw a circle in radar space
		draw_circle(pos, 2, Color(1,1,1,1.0-O))
	# draw a circle for the radar center (you are here)
	draw_circle(Vector2(0,0), 3, Color(0,1,0))



