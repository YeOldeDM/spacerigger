
extends PanelContainer

onready var game = get_node('/root/Game')

onready var zone = get_node('box/info/values/Zone')
onready var dest = get_node('box/info/values/Dest')


func process():
	var ship = game.get_player()
	if ship:
		var zone_txt = 'Nil'
		var dest_txt = '--'
		if ship.in_warp_zone:
			zone_txt = ship.in_warp_zone.get_name()
			dest_txt = ship.in_warp_zone.destination +' - '+\
						ship.in_warp_zone.target_node
		zone.set_text(zone_txt)
		dest.set_text(dest_txt)


