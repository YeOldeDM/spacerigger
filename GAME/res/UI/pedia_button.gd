
extends TextureButton

export var go_to_entry = "welcome"



func _on_TextureButton_pressed():
	SoundMan.play('beep')
	if get_owner():
		get_node('/root/Game').pedia(go_to_entry)
