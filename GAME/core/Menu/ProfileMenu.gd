
extends Control

onready var List = get_node('Profiles/List/scroll/box')
onready var Info = get_node('GameView/Text')
onready var Accept = get_node("Accept")

var profilepanel = preload('res://core/Menu/ProfilePanel.tscn')

var current_profile = null	#current selected profile

var menu_slide = 5





func show_current_profile_info():
	if current_profile == null:
		Info.clear()
		return
	var P = current_profile
	var cdate = P.get_value('CREATION','date')
	var ctime = P.get_value('CREATION','time')
	var name = P.get_value('CREATION', 'profile_name')
	Info.clear()
	Info.append_bbcode('[color=#f5ea41]Name:[/color] '+name)
	Info.newline()
	var datetxt = Format.dict2date(cdate)+" @ "+Format.dict2time(ctime)
	Info.append_bbcode('[color=#f5ea41]Created on:[/color] '+datetxt)
	Info.newline()
	update_accept_button()
	
	



func update_profiles():
	var profiles = Data.get_profile_names()
	for i in List.get_children():
		i.queue_free()
	if not profiles.empty():
		for pro in profiles:
			print(pro)
			add_item(pro)
	update_accept_button()
	
func update_accept_button():
	if current_profile:
		if Accept.is_disabled():
			Accept.set_disabled(false)
	else:
		if !Accept.is_disabled():
			Accept.set_disabled(true)

func add_item(profile):
	var data = Data.load_profile(profile)
	if data:
		var panel = profilepanel.instance()
		panel.set_meta('name', profile)
		panel.set_meta('playtime', 0)
		List.add_child(panel)
		panel.set_data()
	else:
		OS.alert("Error while loading profile: "+profile)








func _ready():
	var rect = get_viewport().get_rect().size
	get_node('Camera').set_pos(Vector2(rect.width/2,rect.height/2))
	update_profiles()
	#set_process(true)

func _process(delta):
	var m_pos = get_viewport().get_mouse_pos()
	var rect = get_viewport().get_rect().size
	var mid = Vector2(rect.width/2,rect.height/2)
	var x = m_pos.x / ((rect.height/rect.width)*menu_slide)
	var y = m_pos.y / menu_slide
	get_node('Camera').set_global_pos(mid+(Vector2(x,y)))





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
	if removed != OK:
		OS.alert("Error while trying to delete profile: "+name)
	update_profiles()
	show_current_profile_info()
