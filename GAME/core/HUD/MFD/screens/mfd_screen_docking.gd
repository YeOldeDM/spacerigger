
extends PanelContainer

onready var game = get_node('/root/Game')
onready var hud = game.hud

onready var box = get_node('box')


var mfd

var current_own_dock = 0
var current_target_dock = 0


func init():
	pass
	
func process():
	var ship = game.get_player()
	if ship:
		_draw_own_dock()
		
		if ship.target:
			_draw_target()
			if 'docks' in ship.target:
				_draw_target_dock()
				_draw_docking_info()

func _draw_own_dock():
	var ship = game.get_player()
	if ship:
		var txt = "O: "+ship.docks.get_child(current_own_dock).dock_name
		box.get_node('own_dock').set_text(txt)

func _draw_target():
	var ship = game.get_player()
	if ship:
		var T = ship.target
		var txt = "T: "+T.Designation
		box.get_node('target/vessel').set_text(txt)
		
func _draw_target_dock():
	var ship = game.get_player()
	if ship:
		var Td = ship.target.docks
		var D = Td.get_child(min(current_target_dock, Td.get_child_count()-1))
		var txt = "D: "+D.dock_name
		box.get_node('target/dock').set_text(txt)

func _draw_docking_info():
	var ship = game.get_player()
	if ship:
		var O = ship.docks.get_child(current_own_dock)
		var T = ship.target.docks.get_child(current_target_dock)
		var D = (T.get_global_pos() - O.get_global_pos()).length()
		var devA = O.get_direction_deviation(T)
		var devP = O.get_positional_deviation(T)
		var Atxt = "DevA: "+str(devA).pad_decimals(2)
		var Ptxt = "DevP: "+str(devP).pad_decimals(2)
		var Dtxt = "Dist.: "+str(D*0.1).pad_decimals(2)
		box.get_node('dev_ang').set_text(Atxt)
		box.get_node('dev_pos').set_text(Ptxt)
		box.get_node('distance').set_text(Dtxt)
		