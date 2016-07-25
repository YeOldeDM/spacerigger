
extends Control

onready var list = get_node('Profiles/List/scroll/box')

var profilepanel = preload('res://core/Menu/ProfilePanel.tscn')

var current_profile = null

func update_profiles():
	var profiles = Data.get_profile_names()
	if not profiles.empty():
		for i in list.get_children():
			i.queue_free()
		for pro in profiles:
			print(pro)
			add_item(pro)



func add_item(profile):
	var data = Data.load_profile(profile)
	if data:
		var panel = profilepanel.instance()
		panel.set_meta('name', profile)
		panel.set_meta('playtime', data.get_value('DATA','play time'))
		list.add_child(panel)
		panel.set_data()
	else:
		OS.alert("Error while loading profile: "+profile)


func _ready():
	update_profiles()





func _on_New_pressed():
	get_node('NewProfileDialog').popup_centered()
	get_node('NewProfileDialog/box/Name').grab_click_focus()




func _on_NewProfileDialog_about_to_show():
	get_node('NewProfileDialog/box/Name').grab_click_focus()
