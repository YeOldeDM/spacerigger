
extends PanelContainer

#	MFD HUDpanel Node
#
#	Process input from MFD
#	node buttons.

# Children
onready var funcbox = get_node('box/func')
onready var display = funcbox.get_node('Display')

# Powered flag
var powered = true

# Current MFD module
var module = 'null'
# MFD Mode (0=display, 1=help)
var mode = 0

# Module selecting flag
var selecting = false


#####################
#	PUBLIC METHODS	#

# Get current display node
func get_screen():
	return display.get_child(0)

# Set current display node
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
		if screen.has_method('init'):
			screen.call('init')

# Toggle power mode
func toggle_powered():
	if powered:
		powered = false
		set_screen('nopower')
	else:
		powered = true
		set_screen(module)

# Make clicky sound ;)
func click():
	SoundMan.play('click')





#########################
#	PRIVATE METHODS		#

# Init
func _ready():
	set_screen(module)

# MFD Main Function Button pressed (bottom row)
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

# MFD Function Button pressed (left/right side)
func _function( id ):
	if powered:
		var sig = "function"+str(id)
		var screen = get_screen()
		if screen.get('script/script'):
			if screen.has_method(sig):
				screen.call(sig)
				#print(sig)
			else:
				print("No such "+sig)


# Process Left-side Button press
func _on_ButtonsLeft_button_selected( button_idx ):
	click()
	_function(button_idx)

# Process Right-side Button press
func _on_ButtonsRight_button_selected( button_idx ):
	click()
	var length = funcbox.get_node('ButtonsLeft').get_button_count()
	_function(button_idx + length)

# Process Bottom-side Button press
func _on_ButtonsBottom_button_selected( button_idx ):
	click()
	_mainFunction(button_idx)
