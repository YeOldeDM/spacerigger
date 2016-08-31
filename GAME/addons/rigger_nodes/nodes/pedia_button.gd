
extends TextureButton
tool

export var Subject = 'welcome'


func _enter_tree():
	set_normal_texture(preload('res://assets/graphics/hud/common/help_button_normal.png'))
	set_hover_texture(preload('res://assets/graphics/hud/common/help_button_hover.png'))
	set_pressed_texture(preload('res://assets/graphics/hud/common/help_button_pressed.png'))
	set_click_on_press(true)
	
func _pressed():
	get_node('/root/Game').pedia(Subject)