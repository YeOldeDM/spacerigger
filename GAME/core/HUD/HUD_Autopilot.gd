
extends PanelContainer

const AFA_PROGRADE = 0
const AFA_RETROGRADE = 1
const AFA_OFF = 2

const RID_ANGULAR = 0
const RID_LINEAR = 1
const RID_OFF = 2

onready var game = get_node('/root/Game')

func _ready():
	pass








func _on_AFA_buttons_selected( button_idx ):
	var ship = game.get_player()
	if !ship:	return
	if button_idx == AFA_PROGRADE:
		ship.enable_AFA(0)
	elif button_idx == AFA_RETROGRADE:
		ship.enable_AFA(1)
	elif button_idx == AFA_OFF:
		ship.disable_AFA()


func _on_RID_buttons_selected( button_idx ):
	var ship = game.get_player()
	if !ship:	print("NO");return
	if button_idx == RID_ANGULAR:
		print("ANG")
		ship.enable_angular_dampen()
		ship.disable_linear_dampen()
	elif button_idx == RID_LINEAR:
		ship.enable_linear_dampen()
		ship.disable_angular_dampen()
	elif button_idx == RID_OFF:
		ship.disable_linear_dampen()
		ship.disable_angular_dampen()
