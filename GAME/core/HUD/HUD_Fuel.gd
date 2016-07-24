
extends PanelContainer

onready var game = get_node('/root/Game')

onready var bar = get_node('box/Bar')
onready var vol = get_node('box/Amt')

func process():
	if game.get_player():
		var ship = game.get_player()
		bar.set_max(ship.get('max_fuel'))
		bar.set_value(ship.current_fuel)
		
		var txt = str(ship.current_fuel).pad_decimals(1)+" L"
		vol.set_text("Volume: "+txt)
		


