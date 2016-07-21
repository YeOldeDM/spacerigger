
extends WindowDialog

onready var entrybox = get_node('box/entry')

var current_entry

func _goto(entry):
	prints("entry",entry)
	var text = Pedia.ref(entry)
	if text:
		entrybox.set_bbcode(text)
		current_entry = entry

func _ready():
	Pedia.make_pedia()






func _on_PediaWindow_about_to_show():
	if current_entry:
		_goto(current_entry)
	else:
		_goto('welcome')


func _on_Show_pressed():
	if !is_visible():
		popup_centered()
