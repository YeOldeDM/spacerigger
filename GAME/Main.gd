
extends Control

onready var hud = get_node('HUD/Cont')
var pointer_scn = preload('res://resources/TargetPointer.tscn')

var body_scn = preload('res://resources/SpaceBody.tscn')

onready var ship = get_node('Ship')

func _ready():
	for i in range(12):
		var B = body_scn.instance()
		var x = rand_range(-10000,10000)
		var y = rand_range(-10000,10000)
		B.set_pos(Vector2(x,y))
		get_node('Bodies').add_child(B)
		add_pointer(B)
	
	set_process(true)


func _process(delta):
	for P in hud.get_node('Pointers').get_children():
		var t = get_node('Bodies/'+P.get_meta('target'))
		var A = ship.get_angle_to(t.get_global_pos())
		var D = (t.get_pos() - ship.get_pos()).length()/640
		D = lerp(1.0,3.0,D/64)
		var S = P.get_node('Sprite')
		S.set_scale(Vector2(D,D))
		S.set_opacity(1.0-(D*0.1))
		S.set_rot(A)
	
	update()

func _draw():
	var radar = get_node('HUD/Cont/Radar').get_pos()
	for body in get_node('Bodies').get_children():
		var pos = (ship.get_global_pos() - body.get_global_pos())*0.01
		pos += radar
		#print(pos)
		draw_circle(pos, 4, Color(1,1,1))
	draw_circle(Vector2(200,200), 6, Color(1,1,1))


func add_pointer(target):
	var P = pointer_scn.instance()
	hud.get_node('Pointers').add_child(P)
	P.set_meta('target',target.get_name())
