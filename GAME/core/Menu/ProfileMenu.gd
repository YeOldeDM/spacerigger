
extends Control

onready var list = get_node('Profiles/List/scroll/box')
onready var info = get_node('GameView/Text')

var profilepanel = preload('res://core/Menu/ProfilePanel.tscn')

var current_profile = null	#current selected profile

func show_current_profile_info():
	assert current_profile != null
	var P = current_profile
	var cdate = P.get_value('CREATION','date')
	var ctime = P.get_value('CREATION','time')
	var name = P.get_value('CREATION', 'profile_name')
	info.clear()
	info.append_bbcode('Name: '+name)
	info.newline()
	var datetxt = Format.dict2date(cdate)+" @ "+Format.dict2time(ctime)
	info.append_bbcode('Created on: '+datetxt)
	
	
	

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
		panel.set_meta('playtime', 0)
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


func _on_Delete_pressed():
	if current_profile:
		get_node('DeleteConfirmDialog').popup_centered()



func _on_DeleteConfirmDialog_confirmed():
	assert current_profile != null
	var name = current_profile.get_value('CREATION', 'profile_name')
	current_profile = null
	var removed = Data.delete_profile(name)
	if removed == OK:
		OS.alert("Deleted profile: "+name, "Success!")
	update_profiles()
