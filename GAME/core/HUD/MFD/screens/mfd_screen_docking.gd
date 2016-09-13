
extends PanelContainer

const RED = Color(1,0,0)
const YELLOW = Color(0,1,1)
const GREEN = Color(0,1,0)

const NO_CONTACT = "-NO CONTACT-"
const CONTACT = "=GOOD CONTACT="
const DOCKED = "+DOCKED OK+"

onready var game = get_node('/root/Game')
onready var hud = game.hud

onready var box = get_node('box')
onready var vis = box.get_node('visual')
onready var angle_slider = vis.get_node('AngleSlider')
onready var angle_marker = angle_slider.get_node('AngleMarker')
onready var left_marker = angle_slider.get_node('LeftMarker')
onready var right_marker = angle_slider.get_node('RightMarker')
onready var status = box.get_node('Status')

var slider_rect_x = 112
var slider_center_x = slider_rect_x / 2

var mfd

var current_own_dock = 0



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
		var D = Td.get_child(min(ship.target_dock, Td.get_child_count()-1))
		var txt = "D: "+D.dock_name
		box.get_node('target/dock').set_text(txt)

func _draw_docking_info():
	var ship = game.get_player()
	if ship:
		var O = ship.docks.get_child(current_own_dock)
		var T = ship.target.docks.get_child(ship.target_dock)
		var D = (T.get_global_pos() - O.get_global_pos()).length()
		var devA = rad2deg(O.get_direction_deviation(T))
		var devP = O.get_positional_deviation(T)
		var Atxt = "Dev Ang: "+str(abs(devA)).pad_decimals(2)
		var Ptxt = "Dev Pos: "+str(devP[0]).pad_decimals(2)+", "+str(devP[1]).pad_decimals(2)
		var Dtxt = "Dist.: "+str(D*0.1).pad_decimals(2)
		box.get_node('dev_ang').set_text(Atxt)
		box.get_node('dev_pos').set_text(Ptxt)
		box.get_node('distance').set_text(Dtxt)
		
		if devA < -10 or devA > 10:
			if not angle_marker.is_hidden():
				angle_marker.hide()
		else:
			if angle_marker.is_hidden():
				angle_marker.show()
			var marker_x = slider_center_x + lerp(0, slider_rect_x, devA/20)
			angle_marker.set_pos(Vector2(marker_x,0))
		
		var A = devP[0]
		var B = devP[1]
		
		if A > 200:
			if not left_marker.is_hidden():
				left_marker.hide()
		else:
			if left_marker.is_hidden():
				left_marker.show()
			var marker_x = slider_center_x - lerp(0, slider_rect_x, A/400)
			left_marker.set_pos(Vector2(marker_x, 0))

		if B > 200:
			if not right_marker.is_hidden():
				right_marker.hide()
		else:
			if right_marker.is_hidden():
				right_marker.show()
			var marker_x = slider_center_x + lerp(0, slider_rect_x, B/400)
			right_marker.set_pos(Vector2(marker_x, 0))
		
		var docked = ship.docked
		var touching = ship.docks.get_child(0).touching
		if docked:
			if !status.get_text() == DOCKED:
				status.set('custom_colors/font_color', GREEN)
				status.set_text(DOCKED)
		elif touching:
			if !status.get_text() == CONTACT:
				status.set('custom_colors/font_color', YELLOW)
				status.set_text(CONTACT)
		else:
			if !status.get_text() == NO_CONTACT:
				status.set('custom_colors/font_color', RED)
				status.set_text(NO_CONTACT)