
extends PanelContainer

onready var game = get_node('/root/Game')

onready var date = get_node('box/Date/Label')
onready var time = get_node('box/Time/Label')

func process():
	_draw_time()

func _draw_time():
	var t = int(game.Time)
	date.set_text(Format.date(t))
	time.set_text(Format.time(t))
	


