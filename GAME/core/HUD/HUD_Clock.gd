
extends PanelContainer

onready var game = get_node('/root/Game')

onready var date = get_node('box/Date/Label')
onready var time = get_node('box/Time/Label')
onready var stopwatch = get_node('box/Stopwatch/Time/Label')



func process():
	_draw_time()

func _draw_time():
	var t = int(game.Time)
	date.set_text(Format.date(t))
	time.set_text(Format.time(t))
	stopwatch.set_text(Format.time(game.stopwatch_time))





func _on_Start_pressed():
	game.stopwatch_running = true


func _on_Stop_pressed():
	game.stopwatch_running = false


func _on_Reset_pressed():
	game.stopwatch_time = 0
	_on_Stop_pressed()
