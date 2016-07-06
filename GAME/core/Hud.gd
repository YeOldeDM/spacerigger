
extends Control




func _ready():
	set_process(true)

func _process(delta):
	update()
	
func _draw():
	var ship = get_node('../../Ship')
	var center = ship.get_global_transform_with_canvas().get_origin()
	var linvel = ship.get_linear_velocity()
	draw_line(center, center - linvel, Color(1,0,0,0.25), 4)
	draw_string(preload('res://assets/fonts/hack10.fnt'),center-linvel,"L.V. "+str(linvel.length()).pad_decimals(2), Color(1,0,0))


