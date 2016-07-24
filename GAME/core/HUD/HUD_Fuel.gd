
extends PanelContainer

onready var game = get_node('/root/Game')

onready var bar = get_node('box/Bar')

func process():
	if game.get_player():
		var ship = game.get_player()
		bar.set_max(ship.max_fuel)
		bar.set_value(ship.current_fuel)
		


