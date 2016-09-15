
extends TextureButton
tool

export(String) var label_text = "ABC" setget _set_label_text
export(int, "top", "bottom") var label_placement = 0 setget _set_label_placement

export var has_error = false setget _set_has_error

var tex_off = preload('res://assets/graphics/hud/common/switch_off.png')
var tex_on = preload('res://assets/graphics/hud/common/switch_on.png')
var tex_err = preload('res://assets/graphics/hud/common/switch_err.png')

onready var label = Label.new()

func _set_label_text(value):
	label_text = value

func _set_label_placement(value):
	label_placement = value

func _set_has_error(value):
	if has_error and !value:
		set_pressed_texture(tex_on)
	elif !has_error and value:
		set_pressed_texture(tex_err)
	has_error = value
	
func _enter_tree():
	set_toggle_mode(true)
	set_normal_texture(tex_off)
	set('has_error', has_error)
	add_child(label)
	


