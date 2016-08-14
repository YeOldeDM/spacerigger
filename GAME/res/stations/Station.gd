
extends RigidBody2D

onready var docks = get_node('Docks')

export var name = "Godot Station"
export var station_class = "Civilian"
export var station_type = "Habitat"

export var Designation = "ST-GOD-A01"




func _ready():
	config()


func config():
	var file = ConfigFile.new()
	file.set_value("SUPPLY", 'energy', 1000)
	var saved = file.save('res://station_template.ini')
	for child in docks.get_children():
		child.owner = self
	
	
