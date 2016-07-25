
extends PanelContainer

onready var info = get_node('box/info')

func set_data():
	print(get_meta_list())
	info.get_node('Name').set_text(get_meta('name'))
	var time = str(get_meta('playtime'))
	info.get_node('Playtime').set_text("Total Play Time: "+time)




func _on_Selector_pressed():
	get_node('/root/Menu').current_profile = Data.load_profile(get_meta('name'))
	