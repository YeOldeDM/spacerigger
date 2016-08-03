
extends PanelContainer

onready var game = get_node('/root/Game')

onready var bar = get_node('box/Bar')
onready var vol = get_node('box/Amt')
onready var use = get_node('box/Use')

func process():
	if game.get_player():
		var ship = game.get_player()
		bar.set_max(ship.get('max_fuel'))
		bar.set_value(ship.current_fuel)
		
		var ftxt = str(ship.current_fuel).pad_decimals(1)+" L"
		var utxt = str(-ship.current_fuel_use).pad_decimals(2)+" L/s"
		vol.set_text("Volume: "+ftxt)
		use.set_text("Rate: "+ utxt)
		


