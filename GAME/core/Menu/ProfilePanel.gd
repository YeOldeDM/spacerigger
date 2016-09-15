
extends Control

onready var info = get_node('box/info')

func set_data():
	info.get_node('Name').set_text(get_meta('name'))
	var time = str(get_meta('playtime'))
	info.get_node('Playtime').set_text("Total Play Time: "+time)




func _on_Selector_pressed():
	get_node('/root/ProfileMenu').current_profile = Data.load_profile(get_meta('name'))
	get_node('/root/ProfileMenu').show_current_profile_info()
	