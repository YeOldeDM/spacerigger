
extends WindowDialog

onready var nameline = get_node('box/Name')
onready var OK = get_node('box/Functions/OK')

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass




func _on_NewProfileDialog_about_to_show():
	get_node('box/Name').grab_focus()


func _on_Name_text_changed( text ):
	text = str(text).strip_edges()
	if text != "" and !text.begins_with('.'):
		OK.set_disabled(false)
	else:
		OK.set_disabled(true)


func _on_Cancel_pressed():
	hide()




func _on_OK_pressed():
	var name = nameline.get_text().strip_edges()
	var new_pro = Data.new_profile(name)
	if new_pro == FAILED:
		OS.alert("This profile name already exists!")
		return
	get_parent().update_profiles()
	hide()
