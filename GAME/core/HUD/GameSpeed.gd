
extends PanelContainer

onready var buttons = get_node('box/SpeedSelector')


func click():
	SoundMan.play('click')

func _on_SpeedSelector_button_selected( button_idx ):
	click()
	var factor = buttons.get_button_text(button_idx).right(1)
	factor = factor.to_float()
	OS.set_time_scale(factor)
	print("SET GAME TIME TO "+str(factor))
