
extends PanelContainer

onready var box = get_node('box')

onready var game = get_node('/root/Game')

var mfd

func process():
	if game.get_player():
		var ship = game.get_player()
		var lv = ship.get_linear_velocity().length()*0.1
		var av = abs(ship.get_angular_velocity())
		var hd = ship.get_rotd()+180.0
		
		var mass = ship.get_total_mass()
		var simmain = ship.delta_v_main*0.1
		var sircs = ship.delta_v*0.1
		
		set_value('velocity', 'linear', lv)
		set_value('velocity', 'angular', av)
		set_value('velocity', 'heading', hd)
		
		set_value('info', 'mass', mass)
		set_value('info', 'main_impulse', simmain)
		set_value('info', 'rcs_impulse', sircs)

func set_value(category, item, value):
	var itm = box.get_node(category+'/'+item+'/Value')
	var txt = str(value).pad_decimals(2)
	itm.set_text(txt)




