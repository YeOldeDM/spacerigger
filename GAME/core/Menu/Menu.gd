
extends Control

# member variables here, example:
# var a=2

# var b="textvar"

func update_profiles():
	var profiles = Data.get_profile_names()
	if not profiles.empty():
		for pro in profiles:
			print(pro)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass




func _on_New_pressed():
	get_node('NewProfileDialog').popup_centered()
	get_node('NewProfileDialog/box/Name').grab_click_focus()




func _on_NewProfileDialog_about_to_show():
	get_node('NewProfileDialog/box/Name').grab_click_focus()
