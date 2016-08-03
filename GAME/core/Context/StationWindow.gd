
extends PopupPanel

var station=null	# Station object the popup is currently referencing.

onready var welcome_msg = get_node('box/title/Welcome')

func _ready():
	popup()

func _set_title(name):
	var txt = "Welcome to "+name+"!"
	welcome_msg.set_text(txt)


func _on_StationWindow_about_to_show():
	if station:
		_set_title(station.get_name())
