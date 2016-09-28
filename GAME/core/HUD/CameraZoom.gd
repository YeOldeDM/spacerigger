
extends PanelContainer

onready var game = get_node('/root/Game')

onready var slider = get_node('box/Slider')
onready var buttons = get_node('box/ZoomButton')






func _on_ZoomButton_button_selected( button_idx ):
	var fac = buttons.get_button_text(button_idx).right(1).to_float()
	game.hud.set_camera_zoom(fac,true)
