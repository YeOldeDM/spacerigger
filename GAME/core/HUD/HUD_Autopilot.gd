
extends PanelContainer

onready var game = get_node('/root/Game')

func _ready():
	for node in get_node('box').get_children():
		if node extends VBoxContainer:
			var pedia_button = node.get_node('title/?')
			var arg = 'autopilot_'+node.get_name()
			print(arg)
			pedia_button.connect("pressed", game, '_show_pedia',[arg])


