
extends Control




func _ready():
	set_process(true)

func _process(delta):
	update()
	
func _draw():
	var ship = get_node('../../Ship')
	var center = Vector2(64, 400)#ship.get_global_transform_with_canvas().get_origin()
	var linvel = ship.get_linear_velocity()
	var pro_point = center-linvel.rotated(-ship.get_rot()).normalized()*clamp(linvel.length()*.5, 16, 64)
	draw_line(center, pro_point, Color(1,0,0,0.25), 4)
	draw_string(preload('res://assets/fonts/hack10.fnt'),pro_point,"L.V. "+str(linvel.length()).pad_decimals(2), Color(1,0,0))


