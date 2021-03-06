
extends PanelContainer

onready var game = get_node('/root/Game')
onready var hud = game.hud

onready var box = get_node('box')

onready var location = box.get_node('Location')

onready var pos = box.get_node('position')
onready var distance = box.get_node('distance')

var mfd

var func_labels = {}

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func init():
	if game.get_world():
		var world = game.get_world()
		set_location(world.get_name())
	
func process():
	if game.get_player():
		var ship = game.get_player()
		var pos = ship.get_global_pos()*0.1
		var x = pos.x
		var y = pos.y
		set_position(x,y)

		var d = pos.length()
		set_distance(d)
	if location.get_text() != game.get_world().get_name():
		set_location(game.get_world().get_name())


func set_location(name):
	location.set_text(name)


func set_position(x,y):
	var X = str(x).pad_decimals(2)
	var Y = str(y).pad_decimals(2)
	
	pos.get_node('X').set_text("X "+X)
	pos.get_node('Y').set_text("Y "+Y)

func set_distance(d):
	var D = str(d).pad_decimals(2)
	
	distance.get_node('Value').set_text(D+" m")