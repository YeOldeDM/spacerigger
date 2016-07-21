
extends PanelContainer

# Game node
onready var game = get_node('/root/Game')


# Shortcuts
onready var systems = get_node('box/Systems') 

# Instanced scenes
onready var sys_panel = preload('res://res/HUD/SystemControl.tscn')

#func _ready():
#	init()
#	refresh()

func clear():
	if !systems.get_children().empty():
		for sys in systems.get_children():
			sys.queue_free()

func init():
	if game.control.controlled:
		var ship = game.control.controlled
		clear()
		for key in ship.systems:
			var cont = sys_panel.instance()
			systems.add_child(cont)
			cont.get_node('Label').set_text(key)
			cont.get_node('Switch').connect("toggled",self,"_set_control",[key,cont.get_node('Switch')])


func _set_control( state, system, origin ):
	printt(state,system)
	if game.control.controlled:
		var ship = game.control.controlled
		ship.systems[system] = state
	origin.release_focus()
	
func refresh():
	if game.control.controlled:
		var ship = game.control.controlled
		for key in ship.systems:
			systems.get_node(key).set_pressed(ship.systems[key])


func process():
	pass
