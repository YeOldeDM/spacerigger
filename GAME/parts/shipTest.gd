
extends Control

onready var cont_rcs_right1 = Vector2(0,0)
onready var cont_rcs_right2 = Vector2(0,0)

onready var cont_rcs_left1 = Vector2(0,0)
onready var cont_rcs_left2 = Vector2(0,0)

onready var cont_thrust1 = Vector2(0,0)
onready var cont_thrust2 = Vector2(0,0)

func _ready():
	set_process(true)

func _process(delta):
	update()

func _draw():
	draw_line(cont_rcs_right1,cont_rcs_right2,Color(1,1,1))
	draw_line(cont_rcs_left1,cont_rcs_left2,Color(1,1,1))
	draw_line(cont_thrust1,cont_thrust2,Color(1,1,1))


