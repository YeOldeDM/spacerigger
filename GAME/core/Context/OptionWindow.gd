
extends PanelContainer

onready var env = get_node('/root/Game/Env').get_environment()






func _on_Bloom_toggled( pressed ):
	env.set_enable_fx(Environment.FX_GLOW, pressed)




func _on_HDR_toggled( pressed ):
	env.set_enable_fx(Environment.FX_HDR, pressed)


func _on_Brightness_value_changed( value ):
	env.fx_set_param(Environment.FX_PARAM_BCS_BRIGHTNESS, value/10)


func _on_Contrast_value_changed( value ):
	env.fx_set_param(Environment.FX_PARAM_BCS_CONTRAST, value/10)


func _on_Saturation_value_changed( value ):
	env.fx_set_param(Environment.FX_PARAM_BCS_SATURATION, value/10)


func _on_Close_pressed():
	get_tree().set_pause(false)
	hide()
