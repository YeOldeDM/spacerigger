extends VBoxContainer


onready var label_ob = get_node('Label')
export var label = "ABC"

var on = false
var error = false setget _set_error

onready var button = get_node('Button')

var texture_on = preload('res://assets/graphics/hud/common/switch_on.png')
var texture_error = preload('res://assets/graphics/hud/common/switch_err.png')

func _ready():
	_set_label(label)


func _set_label( string ):
	label = string
	label_ob.set_text(label)


func _set_error( is_error ):
	error = is_error
	if on:
		if is_error:
			if button.get_pressed_texture() != texture_error:
				button.set_pressed_texture(texture_error)
		else:
			if button.get_pressed_texture() != texture_on:
				button.set_pressed_texture(texture_on)



func _on_Button_toggled( pressed ):
	set('on', pressed)
	if pressed:
		_set_error(error)
	SoundMan.play('click')