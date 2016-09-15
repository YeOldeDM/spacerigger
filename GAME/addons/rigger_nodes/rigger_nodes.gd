
extends EditorPlugin
tool

const PATH = 'res://addons/rigger_nodes/nodes/'

func _enter_tree():
	_create("Pedia Button", "TextureButton", 'pedia_button')
	_create("Function Switch", "TextureButton", 'function_switch')

func _exit_tree():
	remove_custom_type("Pedia Button")
	remove_custom_type("Function Switch")


func _create(name, base, filename):
	var script = load(PATH+filename+'.gd')
	var icon = load(PATH+filename+'.png')
	add_custom_type(name, base, script, icon)