
extends PanelContainer

onready var funcbox = get_node('box/func')
onready var display = funcbox.get_node('Display')

var powered = true

var module = 'null'
var mode = 0

var selecting = false


func _ready():
	set_screen(module)

func get_screen():
	return display.get_child(0)

func set_screen( name ):
	var path = 'res://core/HUD/MFD/screens/mfd_screen_'+name+'.tscn'
	var screen = load(path).instance()
	if !display.get_children().empty():
		for i in display.get_children():
			i.queue_free()
	display.add_child(screen)
	
	if name != 'nopower':
		module = name
	if screen.get('script/script'):
		screen.mfd = self

	

func _mainFunction( id ):
	if id == 0 and powered:
		# Select MFD module to display
		if selecting:
			selecting = false
			set_screen(module)
		else:
			selecting = true
			set_screen('select')
		
	if id == 1 and powered:
		# Toggle MFD display mode (output/help)
		pass
		
	if id == 2:
		# Toggle powered
		toggle_powered()




func _function( id ):
	if powered:
		var sig = "function"+str(id)
		var screen = get_screen()
		if screen.get('script/script'):
			if screen.has_method(sig):
				screen.call(sig)
				print(sig)
			else:
				print("No such "+sig)






func toggle_powered():
	if powered:
		powered = false
		set_screen('nopower')
	else:
		powered = true
		set_screen(module)




func _on_ButtonsLeft_button_selected( button_idx ):
	_function(button_idx)


func _on_ButtonsRight_button_selected( button_idx ):
	var length = funcbox.get_node('ButtonsLeft').get_button_count()
	_function(button_idx + length)


func _on_ButtonsBottom_button_selected( button_idx ):
	_mainFunction(button_idx)
