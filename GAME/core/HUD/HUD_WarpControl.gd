
extends PanelContainer

onready var game = get_node('/root/Game')

onready var zone = get_node('box/info/values/Zone')
onready var dest = get_node('box/info/values/Dest')

var target_node

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

func _ready():
	var ped_button = get_node('box/title/?')
	ped_button.connect("pressed", game, "_show_pedia",['control_warpdrive'])

func _on_Prev_pressed():
	SoundMan.play('click')


func _on_Next_pressed():
	SoundMan.play('click')
